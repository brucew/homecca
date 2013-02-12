class AddTodoItemReminderOn < ActiveRecord::Migration
  def self.up
    add_column :todo_items, :reminder_on, :date
    rename_column :todo_items, :due_at, :due_on

    todo_items = TodoItem.all
    todo_items.each do |todo_item|
      todo_item.reminder_on = todo_item.due_on - 1.day unless todo_item.due_on.nil?
      todo_item.save
    end
  end

  def self.down
    remove_column :todo_items, :reminder_on
  end
end
