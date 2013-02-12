class DeleteRequestsStatus < ActiveRecord::Migration
  def self.up
    remove_column :requests, :status
  end

  def self.down
    add_column :requests, :status, :string
  end
end
