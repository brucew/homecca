class AddUnskilled < ActiveRecord::Migration
  def self.up
    add_column :requests, :unskilled, :boolean, :default => false
    add_column :users, :unskilled, :boolean, :default => false
    Request.all.each do |r|
      r.unskilled = false
      r.save
    end
    User.all.each do |u|
      u.unskilled = false
      u.save
    end
  end

  def self.down
    remove_column :requests, :unskilled
    remove_column :users, :unskilled
  end
end
