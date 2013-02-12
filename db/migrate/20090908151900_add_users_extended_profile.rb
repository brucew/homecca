class AddUsersExtendedProfile < ActiveRecord::Migration
  def self.up
    add_column :users, :address, :string
    add_column :users, :phone, :string, :limit => 13
    add_column :users, :site, :string
    add_column :users, :lat, :decimal
    add_column :users, :lng, :decimal
    add_column :users, :compensation, :string, :limit => 5
    add_column :users, :about, :text
  end

  def self.down
    remove_column :users, :address
    remove_column :users, :phone
    remove_column :users, :site
    remove_column :users, :lat
    remove_column :users, :lng
    remove_column :users, :compensation
    remove_column :users, :about
  end
end
