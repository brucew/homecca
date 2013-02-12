class AddRequestsState < ActiveRecord::Migration
  def self.up
    add_column :requests, :state, :string
  end

  def self.down
    remove_column :requests, :state
  end
end
