class RenameOffersUserid < ActiveRecord::Migration
  def self.up
    rename_column :offers, :user_id, :provider_id
  end

  def self.down
    rename_column :offers, :provider_id, :user_id
  end
end
