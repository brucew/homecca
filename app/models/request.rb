class Request < ActiveRecord::Base
  belongs_to :requester, :class_name => 'User'
  belongs_to :provider
  belongs_to :accepted_offer, :class_name => 'Offer', :autosave => true
  has_many :offers, :autosave => true
  has_many :offerers, :through => :offers
  has_one :rating
  has_many :pics, :as => :picable, :dependent => :destroy
  PIC_MAX = 6

  accepts_nested_attributes_for :pics, :allow_destroy => true,
                                :reject_if => proc {
                                    |attributes| attributes[:pic].nil?
                                }

  acts_as_mappable
  acts_as_taggable_on :tags

  serialize :state

  NEARBY_DISTANCE = User::NEARBY_DISTANCE
  STATES = [:open, :offer_accepted, :removed, :completed]
  ACTIVE_STATES = [:open, :offer_accepted]
  ANY_JOB_TYPE = '-- any --'
  MISC_JOB_TYPE = ['Anything Else']
  JOB_TYPES = [
      'Basement', 'Bathroom', 'Blinds', 'Cabinetry', 'Carpentry', 'Ceilings and Walls', 'Ceiling Fans',
      'Cleaning', 'Concrete Work', 'Counter Top', 'Curtains', 'Decks', 'Doors', 'Driveway',
      'Electrical Wiring', 'Fencing', 'Fireplaces', 'Flooring', 'Floor and Wall Tiling', 'Foundation',
      'Furniture', 'Framing', 'Garage Doors', 'Gutters', 'Heating and Air Conditioning',
      'Hot Tubs and Spas', 'Inspection', 'Insulation', 'Kitchen', 'Large Appliances', 'Landscaping',
      'Lawncare', 'Lighting', 'Locks', 'Molding', 'Moving', 'Paint', 'Patio', 'Pest Control',
      'Plumbing', 'Porch', 'Roofing', 'Safety', 'Security', 'Senior or Handicap Living Modification', 'Septic',
      'Shelving', 'Skylights', 'Solar Panels', 'Soundproofing', 'Sprinklers', 'Stonework', 'Storage',
      'Swimming Pool', 'Waste Removal', 'Water Purification and Softening', 'Windows'
  ].sort

  cattr_reader :per_page
  @@per_page = 30

  attr_accessor :invitations

  attr_protected :state, :active

  scoped_search :on => :name
  scoped_search :in => :tags, :on => :name

  named_scope :active, :conditions => {:active => true}
  named_scope :open, :conditions => {:state => :open}
  named_scope :past, :conditions => {:active => false}
  named_scope :near, lambda { |origin|
    distance_sql = self.distance_sql(origin);
    {:select => "requests.*, #{distance_sql} as distance", :conditions => "#{distance_sql} <= #{NEARBY_DISTANCE}"}
  }
  named_scope :sorted_by, lambda { |sort_order| {:order => sort_order} }

  validates_inclusion_of :state, :in => STATES
  validates_presence_of :name, :description
#  validates_presence_of :skills, :unless => :unskilled?
#  validates_inclusion_of :unskilled, :in => [true, false]
  validates_inclusion_of :job_type, :in => JOB_TYPES + MISC_JOB_TYPE, :message => 'not selected'
  validates_length_of :name, :maximum => 255, :allow_blank => true
  validates_size_of :pics, :maximum => PIC_MAX, :message => ": Too many photos (maximum #{PIC_MAX})"
#  validate :empty_skills_if_unskilled

#  def empty_skills_if_unskilled
#    if self.unskilled? and not self.skills.nil?
##      errors.add(:skills, 'must be empty for unskilled jobs')
#      self.skills = nil
#    end
#  end

#validate :requester_is_provider_if_trading
#
#def requester_is_provider_if_trading
#  if self.trade? and not self.requester.provider?
#    errors.add(:compensation, 'cannot include trade unless you become a skill provider')
#  end
#end
#
#validate :compensation_chosen
#
#def compensation_chosen
#  unless self.paid? or self.trade? or self.volunteer?
#    errors.add(:compensation, 'must be chosen')
#  end
#end

  validate :geo_located

  def geo_located
    unless self.lat and self.lng
      errors.add(:location, 'is invalid')
    end
  end

  cattr_reader :per_page
  @@per_page = 30

  def before_validation
    if self.location and self.location_changed?
      loc = GeoKit::Geocoders::GoogleGeocoder.geocode(location)
      if loc.success
        self.lat = loc.lat
        self.lng = loc.lng
        city = loc.city || loc.district
        city_state = city.nil? ? loc.state : city + ', ' + loc.state
        self.location = city_state
      else
        self.lat = nil
        self.lng = nil
      end
    end
  end

  def before_validation_on_create
    self.state = :open
  end

  # Hack to attempt to fix offer count bug
  def before_save
    self.offers_count = self.offers.count
  end

  def destroy
    self.update_attribute(:state, :removed)
  end

  def accepted_offer=(accepted_offer)
    self[:accepted_offer_id] = accepted_offer.id
    self.provider = accepted_offer.offerer
    self.state = :offer_accepted
  end

  def accepted_offer_id=(accepted_offer_id)
    self.accepted_offer = Offer.find(accepted_offer_id)
  end

  def state=(state)
    self.active = ACTIVE_STATES.include?(state)
    case state
      when :offer_accepted
        self.offers.each do |offer|
          if offer.state == :open
            if offer == self.accepted_offer
              offer.state = :accepted
            else
              offer.state = :closed
            end
          end
        end
      when :removed
        self.offers.each do |offer|
          offer.state = :closed
        end
      when :completed
        self.accepted_offer.state = :completed
    end
    super
  end

#  def skills=(skills)
#    s = Utility::Skills.new(skills)
#    self.tag_list = s.tag_list
#    self[:skills] = skills
#  end

  def job_type=(job_type)
    self.tag_list = [job_type]
    self.cached_tag_list = self.tag_list.to_s
  end

  def job_type
    return self.cached_tag_list || self.tag_list.to_s
  end

  def unused_pics_count
    PIC_MAX - self.pics.count
  end

end