class Vid < ActiveRecord::Base
  belongs_to :vidable, :polymorphic => true

  acts_as_list :scope => :vidable

  validates_presence_of :url
end
