class AddCatalogIdToTodoItems < ActiveRecord::Migration
  def self.up
    add_column :todo_items, :todo_catalogue_item_id, :integer
  end

  def self.down
    remove_column :todo_items, :todo_catalogue_item_id
  end
end
