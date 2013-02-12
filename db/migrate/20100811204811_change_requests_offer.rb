class ChangeRequestsOffer < ActiveRecord::Migration
  def self.up
    add_column :requests, :accepted_offer_id, :integer
  end

  def self.down
    remove_column :requests, :accepted_offer_id
  end
end
