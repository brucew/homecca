class User < ActiveRecord::Base
  include BlueLightSpecial::User

  has_many :requests, :foreign_key => 'requester_id'
  has_many :todo_items, :foreign_key => 'creator_id'

  acts_as_mappable

  AVATAR_WIDTH = '80'
  AVATAR_HEIGHT = '80'
  AVATAR_SIZE = AVATAR_WIDTH + 'x' + AVATAR_HEIGHT

  AVATAR_MID_WIDTH = '60'
  AVATAR_MID_HEIGHT = '60'
  AVATAR_MID_SIZE = AVATAR_MID_WIDTH + 'x' + AVATAR_MID_HEIGHT

  AVATAR_THUMB_WIDTH = '40'
  AVATAR_THUMB_HEIGHT = '40'
  AVATAR_THUMB_SIZE = AVATAR_THUMB_WIDTH + 'x' + AVATAR_THUMB_HEIGHT

  NEARBY_DISTANCE = 10000

  has_attached_file :avatar,
                    :styles => {:original => ["#{AVATAR_SIZE}#", :jpg], :thumb => ["#{AVATAR_THUMB_SIZE}#", :jpg]},
                    :storage => :s3,
                    :s3_credentials => "#{RAILS_ROOT}/config/amazon_s3.yml",
                    :path => 'users/avatars/:id/:style.:extension'

  attr_accessor :email_confirmation

  attr_accessible :avatar, :login, :first_name, :last_name,
                  :email, :email_confirmation, :password, :password_confirmation,
                  :location, :phone, :tag_list, :about, :default_reminder

  named_scope :near, lambda { |o| {:origin => o, :within => NEARBY_DISTANCE} }

  validates_confirmation_of :email

  #validate :geo_located
  #
  #def geo_located
  #  unless self.lat and self.lng
  #    errors.add(:location, "is invalid")
  #  end
  #end

  #def before_validation
  #  if self.location and self.location_changed?
  #    loc = GeoKit::Geocoders::GoogleGeocoder.geocode(location)
  #    if loc.success
  #      self.lat = loc.lat
  #      self.lng = loc.lng
  #      self.location = loc.full_address
  #    else
  #      self.lat = nil
  #      self.lng = nil
  #    end
  #  end
  #end

  def after_update
    if self.default_reminder_changed?
      if self.default_reminder.nil?
        self.todo_items.active.update_all("reminder_on = NULL")
      else
        self.todo_items.active.update_all("reminder_on = due_on - #{self.default_reminder}")
      end
    end
  end

  def name
    return self.first_name + ' ' + self.last_name if self.first_name and self.last_name
  end

  def provider?
    false
  end

  def class_sym
    self.class.to_s.downcase.to_sym
  end

  def past_activity
    self.requests.active_is(false).descend_by_created_at
  end

  # Monkey patch to BlueLightSpecial to correct case sensitivity when running on Postgresql
  # Replaced email with email.downcase
  def email=(email)
    self[:email] = email.downcase unless email.nil?
  end

  # Monkey patch to BlueLightSpecial to correct case sensitivity when running on Postgresql
  # Replaced find_by_email(email) with email_is(email.downcase)
  # This uses Searchlogic plugin
  def self.authenticate(email, password)
    user = email_is(email.downcase).first
    user && user.authenticated?(password) ? user : nil
  end

  def self.find_facebook_user(facebook_session, facebook_uid, access_token = nil)
    return nil unless BlueLightSpecial.configuration.use_facebook_connect && facebook_session && facebook_uid

    begin
      facebook = MiniFB::Session.new(BlueLightSpecial.configuration.facebook_api_key,
                                     BlueLightSpecial.configuration.facebook_secret_key,
                                     facebook_session, facebook_uid)
      facebook_user = facebook.user

#        Untested code to convert Facebook legacy/REST sessions into OAuth access tokens
#      url = MiniFB::graph_base + 'oauth/exchange_sessions/'
#      params = {}
#      params[:client_id] = BlueLightSpecial.configuration.facebook_app_id
#      params[:client_secret] = BlueLightSpecial.configuration.facebook_secret_key
#      params[:sessions] = facebook_session
#      options = {}
#      options[:params] = params
#      options[:method] = :post
#      response = MiniFB::fetch(url, options)

    rescue MiniFB::FaceBookError
      facebook_user = nil
    end
    return nil unless facebook_user

    unless user = ::User.find_by_facebook_uid(facebook_uid)
      user = ::User.find_by_email(facebook_user['email']) || ::User.new
      Notify::user_facebook_connect(user)
    end

    user.tap do |user|
      user.facebook_uid = facebook_uid
      user.facebook_session = facebook_session
      user.email = facebook_user['email']
      user.first_name = facebook_user['first_name']
      user.last_name = facebook_user['last_name']
      user.location = facebook_user['current_location']['name'] unless user.location or facebook_user['current_location'].nil?
      user.save
    end
  end

end
