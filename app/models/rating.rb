class Rating < ActiveRecord::Base
  belongs_to :rater, :class_name => 'User'
  belongs_to :provider
  belongs_to :request

  SCORES = [ 1, 2, 3, 4, 5 ]

  validates_presence_of :rater_id, :provider_id, :request_id
  validates_uniqueness_of :provider_id, :scope => :request_id, :message => 'has already been rated for this request'
  validates_inclusion_of :score, :in => SCORES, :message => 'must be selected'
  validate :rater_not_provider
  def rater_not_provider
    if self.rater_id == self.provider_id
      errors.add_to_base('You cannot rate yourself')
    end
  end

  def after_save
    self.provider.update_attribute(:average_rating, provider.calculate_average_rating)
  end

  def request=(request)
    self[:request_id] = request.id
    self.provider = request.provider
  end
  
  def request_id=(request_id)
    self.request = Request.find(request_id)
  end
  
  #TODO: make Rating return score when cast as integer
  def to_i
    return self.score
  end
end
