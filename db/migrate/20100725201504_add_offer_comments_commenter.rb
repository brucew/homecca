class AddOfferCommentsCommenter < ActiveRecord::Migration
  def self.up
    drop_table :offer_comments
    create_table :offer_comments do |t|
      t.integer :offer_id
      t.integer :commenter_id
      t.text :comment

      t.timestamps
    end
  end

  def self.down
    remove_column :offer_comments, :commenter_id
  end
end
