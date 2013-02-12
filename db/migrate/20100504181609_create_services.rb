class CreateServices < ActiveRecord::Migration
  def self.up
    create_table :services do |t|
      t.integer :seeker_id
      t.integer :provider_id
      t.integer :rating
      t.text :comment
      t.integer :lat
      t.integer :lng

      t.timestamps
    end
  end

  def self.down
    drop_table :services
  end
end
