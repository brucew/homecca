class AddOffersEstimate < ActiveRecord::Migration
  def self.up
    add_column :offers, :estimate, :integer, :default => 0
  end

  def self.down
    remove_column :offers, :estimate
  end
end
