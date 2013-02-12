class AddOffersState < ActiveRecord::Migration
  def self.up
    remove_column :offers, :status
    add_column :offers, :state, :string
    add_column :offers, :active, :boolean, :default => true
  end

  def self.down
    remove_column :offers, :state
    remove_column :offers, :active
    add_column :offers, :status, :text
  end
end
