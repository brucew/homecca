class OfferComment < ActiveRecord::Base
  validates_presence_of :comment
  
  belongs_to :offer
  belongs_to :commenter, :class_name => 'User'
end
