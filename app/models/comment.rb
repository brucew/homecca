class Comment < ActiveRecord::Base
  belongs_to :commenter, :class_name => 'User'
  belongs_to :commentable, :polymorphic => true
  has_many :pics, :as => :picable, :dependent => :destroy, :order => 'position'

  accepts_nested_attributes_for :pics, :allow_destroy => true,
                                :reject_if => proc {
                                    |attributes| attributes[:pic].nil?
                                }

  PIC_MAX = 12
  PIC_SIZES = {
      :thumb => '120x90#',
      :original => '800x600>'
  }

  validates_presence_of :body, :commenter

end
