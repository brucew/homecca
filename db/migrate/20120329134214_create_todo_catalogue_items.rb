class CreateTodoCatalogueItems < ActiveRecord::Migration
  def self.up
    create_table :todo_catalogue_items do |t|
      t.string :short_description
      t.integer :importance
      t.string :categories
      t.string :how_often
      t.string :tabs
      t.integer :difficulty
      t.integer :cost
      t.text :long_description
      t.text :why
      t.text :how
      t.string :wikipedia_url
      t.string :video_urls

      t.timestamps
    end
  end

  def self.down
    drop_table :todo_catalogue_items
  end
end
