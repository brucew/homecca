class ChangeTodoCatalogueItemsCost < ActiveRecord::Migration
  def self.up
    change_column :todo_catalogue_items, :cost, :string
  end

  def self.down
    change_column :todo_catalogue_items, :cost, :integer
  end
end
