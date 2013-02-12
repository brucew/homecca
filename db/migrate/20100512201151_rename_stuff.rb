class RenameStuff < ActiveRecord::Migration
  def self.up
    rename_column :users, :address, :location
    rename_column :services, :comment, :description
    change_column :services, :name, :string
    change_column :services, :status, :string
  end

  def self.down
    rename_column :users, :location, :address
    rename_column :services, :description, :comment
    change_column :services, :name, :text
    change_column :services, :status, :text
  end
end
