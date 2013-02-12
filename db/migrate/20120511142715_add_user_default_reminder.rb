class AddUserDefaultReminder < ActiveRecord::Migration
  def self.up
    add_column :users, :default_reminder, :integer, :default => 1
  end

  def self.down
    remove_column :users, :default_reminder
  end
end
