class AddTodoCatalogueItemCoverPic < ActiveRecord::Migration
  def self.up
    add_column :todo_catalogue_items, :cover_pic_id, :integer
  end

  def self.down
    remove_column :todo_catalogue_items, :cover_pic_id
  end
end
