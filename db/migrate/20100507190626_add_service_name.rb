class AddServiceName < ActiveRecord::Migration
    def self.up
      add_column :services, :name, :text
    end
    def self.down
      remove_column :services, :name
    end
  end
