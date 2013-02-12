class AddServicesRatingComment < ActiveRecord::Migration
    def self.up
      add_column :services, :rating_comment, :text
    end

    def self.down
      remove_column :services, :rating_comment
    end
  end
