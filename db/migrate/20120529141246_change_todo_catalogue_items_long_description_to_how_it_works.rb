class ChangeTodoCatalogueItemsLongDescriptionToHowItWorks < ActiveRecord::Migration
  def self.up
    rename_column :todo_catalogue_items, :long_description, :how_it_works
  end

  def self.down
    rename_column :todo_catalogue_items, :how_it_works, :long_description
  end
end
