class FixLatLngPrecision < ActiveRecord::Migration
  def self.up
    change_column :users, :lat, :decimal, :precision => 15, :scale => 10
    change_column :users, :lng, :decimal, :precision => 15, :scale => 10
    change_column :requests, :lat, :decimal, :precision => 15, :scale => 10
    change_column :requests, :lng, :decimal, :precision => 15, :scale => 10
  end

  def self.down
    change_column :users, :lat, :integer
    change_column :users, :lng, :integer
    change_column :requests, :lat, :integer
    change_column :requests, :lng, :integer
  end
end
