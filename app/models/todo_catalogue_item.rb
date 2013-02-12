class TodoCatalogueItem < ActiveRecord::Base
  has_many :vids, :as => :vidable, :dependent => :destroy
  has_many :pics, :as => :picable, :dependent => :destroy, :order => 'position'
  has_many :todo_items
  belongs_to :cover_pic, :class_name => 'Pic'

  accepts_nested_attributes_for :pics, :allow_destroy => true,
                                :reject_if => proc {
                                    |attributes| attributes[:pic].nil?
                                }
  accepts_nested_attributes_for :vids, :allow_destroy => true,
                                :reject_if => proc {
                                    |attributes| attributes[:url].nil?
                                }

  acts_as_taggable_on :categories, :tabs, :tags

  PIC_MAX = 12
  PIC_SIZES = {
      :thumb => '60x40#',
      :cover => '130x100#',
      :large => '800x600#',
      :original => '2048x1536>'
  }

  IMPORTANCES = {1 => 'High', 2 => 'Medium', 3 => 'Low'}
  CATEGORIES = ['Exterior', 'Interior', 'Heating and Ventilation', 'Plumbing', 'Electricity']
  #HOW_OFTENS = ['Annually', 'Seasonally', 'Monthly']
  TABS = ['Spring', 'Summer', 'Winter', 'Fall', 'Monthly', 'Annually', 'Important']
  DIFFICULTIES = {1 => 'Easy', 2 => 'Medium', 3 => 'Hard'}

  validates_presence_of :short_description
  validates_numericality_of :importance, :only_integer => true, :greater_than => 0,
                            :less_than_or_equal_to => IMPORTANCES.size, :allow_nil => true, :message => 'not selected'
  validates_numericality_of :difficulty, :only_integer => true, :greater_than => 0,
                            :less_than_or_equal_to => DIFFICULTIES.size, :allow_nil => true, :message => 'not selected'
  validates_size_of :pics, :maximum => PIC_MAX, :message => ": Too many photos (maximum #{PIC_MAX})"
  validate do |record|
    record.must_include_each_of(:tab_list, :in => TABS, :allow_empty => true)
    record.must_include_each_of(:category_list, :in => CATEGORIES, :allow_empty => true)
  end

  def how_to_pics
    self.pics.find(:all, :conditions => ['id <> ?', self.cover_pic_id])
  end

  def must_include_each_of(attr, opts={})
    list = self.send(attr)
    unless opts[:allow_empty] and list.empty?
      list.to_a.each do |item|
        errors.add attr, 'has an item not allowed' unless opts[:in].include?(item)
      end
    end
  end

  def unused_pics_count
    PIC_MAX - self.pics.count
  end

end
