class Provider < User

  attr_accessible :volunteer, :paid, :trade, :business_name, :site, :skills

  has_many :provided_requests, :class_name => 'Request'
  has_many :ratings
  has_many :offers, :foreign_key => 'offerer_id'

  has_many :pics, :as => :picable, :dependent => :destroy
  PIC_MAX = 9
  attr_accessible :pics_attributes

  acts_as_taggable_on :tags

  accepts_nested_attributes_for :pics, :allow_destroy => true,
                                :reject_if => proc {
                                    |attributes| attributes[:pic].nil?
                                }

#  named_scope :unskilled, :conditions => {:unskilled => true}
  named_scope :near, lambda { |origin|
    distance_sql = self.distance_sql(origin);
    {:select => "users.*, #{distance_sql} as distance", :conditions => "#{distance_sql} <= #{NEARBY_DISTANCE}"}
  }
  named_scope :sorted_by, lambda { |sort_order| {:order => sort_order} }

  validates_presence_of :skills, :message => "can't be empty"
  validates_length_of :business_name, :site, :maximum => 255
  validates_length_of :phone, :maximum => 20
  validates_size_of :pics, :maximum => PIC_MAX, :message => ": Too many photos (maximum #{PIC_MAX})"

  #validate :compensation_chosen
  #
  #def compensation_chosen
  #  unless self.paid? or self.trade? or self.volunteer?
  #    errors.add(:compensation, 'must be chosen')
  #  end
  #end


  cattr_reader :per_page
  @@per_page = 30

  def provider?
    true
  end

  def calculate_average_rating
    rating = self.ratings.average(:score)
    logger.debug('Average rating')
    logger.debug(rating)
    if (rating != nil)
      rating = ((rating * 2).round) / 2
    else
      rating = 0
    end
    return rating
  end

  def rated_by? (owner)
    if Rating.find_by_user_id_and_owner_id(self, owner)
      return true
    end
    return false
  end

  def set_type
    self[:type] = 'Provider'
  end

    #TODO: Past activity should be a combination of requests and offers
  def past_activity
    Request.past.find(:all, :conditions => ["(requester_id = ? or provider_id = ?)", self.id, self.id],
                      :order => 'updated_at desc')
  end

  def skills
    return self.tag_list
  end

  def skills=(skills)
    self.tag_list = skills
  end

  def unused_pics_count
    PIC_MAX - self.pics.count
  end

end
