class Topic < ActiveRecord::Base
  belongs_to :created_by, :class_name => 'User'
  belongs_to :body, :class_name => 'Comment'
  belongs_to :forum
  has_many :comments, :as => :commentable, :dependent => :destroy

  has_many :pics, :as => :picable, :dependent => :destroy
  PIC_MAX = 6

  accepts_nested_attributes_for :pics, :allow_destroy => true,
                                :reject_if => proc {
                                    |attributes| attributes[:pic].nil?
                                }

  validates_presence_of :title, :body

  def unused_pics_count
    PIC_MAX - self.pics.count
  end

end
