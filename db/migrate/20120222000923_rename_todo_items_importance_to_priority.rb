class RenameTodoItemsImportanceToPriority < ActiveRecord::Migration
  def self.up
    rename_column :todo_items, :importance, :priority
  end

  def self.down
    rename_column :todo_items, :priority, :importance
  end
end
