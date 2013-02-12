class CreateTodoItems < ActiveRecord::Migration
  def self.up
    create_table :todo_items do |t|
      t.string :name
      t.belongs_to :creator
      t.text :notes
      t.boolean :done, :default => false
      t.date :due_at
      t.integer :importance

      t.timestamps
    end
  end

  def self.down
    drop_table :todo_items
  end
end
