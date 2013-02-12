class CreateRatings < ActiveRecord::Migration
  def self.up
    create_table :ratings do |t|
      t.column :user_id, :integer
      t.column :title, :string
      t.column :comments, :text
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :score, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :ratings
  end
end
