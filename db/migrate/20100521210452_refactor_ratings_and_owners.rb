class RefactorRatingsAndOwners < ActiveRecord::Migration
  def self.up
    rename_column :ratings, :user_id, :provider_id
    rename_column :offers, :provider_id, :offerer_id

    remove_column :requests, :rating
    remove_column :requests, :rating_comment

    add_column :ratings, :rater_id, :integer
    add_column :ratings, :request_id, :integer
  end

  def self.down
    rename_column :ratings, :rater_id, :owner_id
    rename_column :ratings, :provider_id, :user_id
    rename_column :offers, :offerer_id, :provider_id

    add_column :requests, :rating, :integer
    add_column :requests, :rating_comment, :text

    remove_column :ratings, :rater_id
    remove_column :ratings, :request_id
  end
end
