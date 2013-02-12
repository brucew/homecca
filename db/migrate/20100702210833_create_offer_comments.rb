class CreateOfferComments < ActiveRecord::Migration
  def self.up
    create_table :offer_comments do |t|
      t.integer :offer_id
      t.text :comment

      t.timestamps
    end
  end

  def self.down
    drop_table :offer_comments
  end
end
