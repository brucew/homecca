class ExpandUsersPhone < ActiveRecord::Migration
  def self.up
    change_column :users, :phone, :string, :limit => 20
  end

  def self.down
    change_column :users, :phone, :string, :limit => 13
  end
end
