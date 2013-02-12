class CreateRequests < ActiveRecord::Migration
  def self.up
    create_table "requests" do |t|
      t.integer  "seeker_id"
      t.integer  "provider_id"
      t.integer  "rating"
      t.text     "description"
      t.integer  "lat"
      t.integer  "lng"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "name"
      t.string   "status"
      t.text     "rating_comment"
    end
  end

  def self.down
    drop_table :requests
  end
end