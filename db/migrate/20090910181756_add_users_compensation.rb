class AddUsersCompensation < ActiveRecord::Migration
  def self.up
    add_column :users, :volunteer, :boolean
    add_column :users, :paid, :boolean
    add_column :users, :trade, :boolean
  end

  def self.down
    remove_column :users, :volunteer
    remove_column :users, :paid
    remove_column :users, :trade
  end
end
