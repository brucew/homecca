class TodoItem < ActiveRecord::Base
  belongs_to :creator, :class_name => 'User'
  belongs_to :todo_catalogue_item

  PRIORITIES = ['high', 'medium', 'normal']

  named_scope :active, :conditions => {:done => false}
  named_scope :due_today, :conditions => {:due_on => Date.today, :done => false}
  named_scope :done, :conditions => {:done => true}
  named_scope :by_created_at, :order => 'created_at DESC'
  named_scope :by_due_on, :order => 'due_on ASC, priority ASC'
  named_scope :by_done_on, :order => 'done_on ASC, priority ASC'
  named_scope :by_priority_due, :order => 'priority ASC, due_on ASC'
  named_scope :by_priority_done, :order => 'priority ASC, done_on ASC'

  validates_presence_of :name, :due_on

  def initialize(attributes = {})
    super(attributes)
    self.priority ||= 3
  end

  def before_save
    self.reminder_on = self.due_on - self.creator.default_reminder.day unless self.creator.default_reminder.nil?
  end

  def priority_label
    return PRIORITIES[self.priority - 1]
  end

  def done=(done)
    self[:done] = done
    self.done_on = Date.today if done
  end
end