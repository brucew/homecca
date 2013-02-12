class AddVidsCaption < ActiveRecord::Migration
  def self.up
    add_column :vids, :caption, :string
  end

  def self.down
    remove_column :vids, :caption
  end
end
