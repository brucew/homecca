class AddServicesStatus < ActiveRecord::Migration
  def self.up
    add_column :services, :status, :text
  end

  def self.down
    remove_column :services, :status
  end
end
