class ChangeOffersServiceToRequest < ActiveRecord::Migration
  def self.up
    rename_column :offers, :service_id, :request_id
  end

  def self.down
    rename_column :offers, :request_id, :service_id
  end
end
