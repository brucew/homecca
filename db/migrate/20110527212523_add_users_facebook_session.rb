class AddUsersFacebookSession < ActiveRecord::Migration
  def self.up
    add_column :users, :facebook_session, :string
  end

  def self.down
    remove_column :users, :facebook_session
  end
end
