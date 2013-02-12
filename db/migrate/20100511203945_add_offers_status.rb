class AddOffersStatus < ActiveRecord::Migration
  def self.up
      add_column :offers, :status, :text
    end

    def self.down
      remove_column :offers, :status
    end
  end

