class FixUsersAverageRating < ActiveRecord::Migration
  def self.up
    change_column :users, :average_rating, :decimal, :precision => 2, :scale => 1
  end

  def self.down
    change_column :users, :average_rating, :integer
  end
end
