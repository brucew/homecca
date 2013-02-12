class AddTodoItemDoneOn < ActiveRecord::Migration
  def self.up
    add_column :todo_items, :done_on, :date
  end

  def self.down
    remove_column :todo_items, :done_on
  end
end
