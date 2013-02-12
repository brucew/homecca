class AddRequestsActive < ActiveRecord::Migration
  def self.up
    add_column :requests, :active, :boolean, :default => true

#    Request.update_all("active = false", ["status = ? OR status = ?", Request::STATUS[:closed], Request::STATUS[:removed]])
  end

  def self.down
    remove_column :requests, :active
  end
end
