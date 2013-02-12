class AddRequestsLocation < ActiveRecord::Migration
  def self.up
    add_column :requests, :location, :string
  end

  def self.down
    remove_column :requests, :location
  end
end
