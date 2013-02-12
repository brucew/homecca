class AddDefaultProviderRating < ActiveRecord::Migration
  def self.up
    change_column :users, :average_rating, :integer, :default => 0
  end

  def self.down
    change_column :users, :average_rating, :integer
  end
end
