class AddVidsPosition < ActiveRecord::Migration
  def self.up
    add_column :vids, :position, :integer
  end

  def self.down
    remove_column :vids, :position
  end
end
