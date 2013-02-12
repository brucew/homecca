class AddAverageRating < ActiveRecord::Migration
  def self.up
    add_column :users, :average_rating, :integer
  end

  def self.down
    remove_column :users, :fb_user_id
  end
end
