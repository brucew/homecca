class AddTagCache < ActiveRecord::Migration
  def self.up
    add_column :users, :cached_tag_list, :string
    add_column :requests, :cached_tag_list, :string
  end

  def self.down
    remove_column :users, :cached_tag_list
    remove_column :requests, :cached_tag_list    
  end
end
