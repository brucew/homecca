class Article < ActiveRecord::Base
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :pics, :as => :picable, :dependent => :destroy
  PIC_MAX = 9

  accepts_nested_attributes_for :pics, :allow_destroy => true,
                                :reject_if => proc {
                                    |attributes| attributes[:pic].nil?
                                }

  STATES = [:draft, :published, :removed]

  validates_presence_of :title, :body

  def initialize(attributes = {})
    super(attributes)
    self.state = :draft
  end

  def unused_pics_count
    PIC_MAX - self.pics.count
  end

end
