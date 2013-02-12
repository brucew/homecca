class Offer < ActiveRecord::Base
  belongs_to :offerer, :class_name => 'Provider'
  belongs_to :request, :counter_cache => true
  has_many :offer_comments, :order => 'created_at DESC'

  serialize :state

  STATES = [:open, :accepted, :rejected, :removed, :closed, :completed]
  ACTIVE_STATES = [:open, :accepted]
  EDITABLE_STATES = [:open, :rejected, :removed]

  attr_protected :state, :active

  named_scope :active, :conditions => {:active => true}
  named_scope :by, lambda { |user| {:conditions => {:offerer_id => user.id}} }

  validates_presence_of :details
  validates_inclusion_of :state, :in => STATES
  validates_numericality_of :estimate, :only_integer => true, :allow_nil => true, :message => 'is not a whole number'

  def before_validation_on_create
    self.read = false
    self.state = :open
  end

  def destroy
    self.update_attribute(:state, :removed)
  end

  def details=(details)
    if self.editable?
      self.read = false
      self.state = :open
    end
    super
  end

  def state=(state)
    self.active = ACTIVE_STATES.include?(state)
    case state
      when :removed
        self.read = true
    end
    super
  end

  def editable?
    EDITABLE_STATES.include?(self.state)
  end

end
