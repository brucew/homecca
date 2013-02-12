class AddPicsCaption < ActiveRecord::Migration
  def self.up
    add_column :pics, :caption, :string
  end

  def self.down
    remove_column :pics, :caption
  end
end
