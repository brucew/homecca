class CreateVids < ActiveRecord::Migration
  def self.up
    create_table :vids do |t|
      t.integer :vidable_id
      t.string :vidable_type
      t.string :url

      t.timestamps
    end

    remove_column :todo_catalogue_items, :video_urls
  end

  def self.down
    add_column :todo_catalogue_items, :video_urls, :string
    drop_table :vids
  end
end
