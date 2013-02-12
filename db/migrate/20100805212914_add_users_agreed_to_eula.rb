class AddUsersAgreedToEula < ActiveRecord::Migration
  def self.up
    add_column :users, :eula_agreed, :boolean, :default => false
  end

  def self.down
    remove_column :users, :eula_agreed
  end
end
