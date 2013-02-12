class RemoveTodoCatalogueItemsTabsAndCategories < ActiveRecord::Migration
  def self.up
    remove_column :todo_catalogue_items, :tabs
    remove_column :todo_catalogue_items, :categories
  end

  def self.down
    add_column :todo_catalogue_items, :tabs, :string
    add_column :todo_catalogue_items, :categories, :string
  end
end
