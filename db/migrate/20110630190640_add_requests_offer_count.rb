class AddRequestsOfferCount < ActiveRecord::Migration
  def self.up
    add_column :requests, :offers_count, :integer, :default => 0
    Request.reset_column_information
    Request.all.each do |request|
      Request.update_counters request.id, :offers_count => request.offers.length
    end
  end

  def self.down
    remove_column :requests, :offers_count
  end
end
