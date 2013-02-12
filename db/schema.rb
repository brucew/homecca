# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120615160845) do

  create_table "articles", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.string   "state",         :default => "--- :draft\n"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by_id"
  end

  create_table "comments", :force => true do |t|
    t.text     "body"
    t.integer  "created_by_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "forums", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "logs", :force => true do |t|
    t.string   "message"
    t.datetime "created_at"
  end

  create_table "offer_comments", :force => true do |t|
    t.integer  "offer_id"
    t.integer  "commenter_id"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "offers", :force => true do |t|
    t.integer  "offerer_id"
    t.integer  "request_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "details"
    t.string   "state"
    t.boolean  "active",     :default => true
    t.boolean  "read"
    t.integer  "estimate",   :default => 0
  end

  create_table "pics", :force => true do |t|
    t.string   "pic_file_name"
    t.string   "pic_content_type"
    t.integer  "pic_file_size"
    t.datetime "pic_updated_at"
    t.integer  "picable_id"
    t.string   "picable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "caption"
    t.integer  "position"
  end

  create_table "ratings", :force => true do |t|
    t.integer  "provider_id"
    t.string   "title"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "score"
    t.integer  "rater_id"
    t.integer  "request_id"
  end

  create_table "requests", :force => true do |t|
    t.integer  "requester_id"
    t.text     "description"
    t.decimal  "lat",               :precision => 15, :scale => 10
    t.decimal  "lng",               :precision => 15, :scale => 10
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "cached_tag_list"
    t.boolean  "active",                                            :default => true
    t.string   "state"
    t.string   "location"
    t.integer  "provider_id"
    t.integer  "accepted_offer_id"
    t.string   "skills"
    t.boolean  "volunteer"
    t.boolean  "paid"
    t.boolean  "trade"
    t.boolean  "unskilled",                                         :default => false
    t.integer  "offers_count",                                      :default => 0
  end

  create_table "services", :force => true do |t|
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

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "todo_catalogue_items", :force => true do |t|
    t.string   "short_description"
    t.integer  "importance"
    t.string   "how_often"
    t.integer  "difficulty"
    t.string   "cost"
    t.text     "how_it_works"
    t.text     "why"
    t.text     "how"
    t.string   "wikipedia_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cover_pic_id"
  end

  create_table "todo_items", :force => true do |t|
    t.string   "name"
    t.integer  "creator_id"
    t.text     "notes"
    t.boolean  "done",                   :default => false
    t.date     "due_on"
    t.integer  "priority"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "todo_catalogue_item_id"
    t.date     "reminder_on"
    t.date     "done_on"
  end

  create_table "topics", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "forum_id"
    t.integer  "created_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "encrypted_password",   :limit => 128
    t.string   "salt",                 :limit => 128
    t.string   "confirmation_token",   :limit => 128
    t.string   "remember_token",       :limit => 128
    t.boolean  "email_confirmed",                                                     :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "location"
    t.string   "phone",                :limit => 20
    t.string   "site"
    t.decimal  "lat",                                 :precision => 15, :scale => 10
    t.decimal  "lng",                                 :precision => 15, :scale => 10
    t.string   "compensation",         :limit => 5
    t.text     "about"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.decimal  "average_rating",                      :precision => 2,  :scale => 1,  :default => 0.0
    t.boolean  "volunteer"
    t.boolean  "paid"
    t.boolean  "trade"
    t.string   "first_name",           :limit => 50
    t.string   "last_name",            :limit => 50
    t.string   "role",                 :limit => 50
    t.string   "facebook_uid",         :limit => 50
    t.string   "password_reset_token", :limit => 128
    t.string   "type"
    t.string   "business_name"
    t.boolean  "eula_agreed",                                                         :default => false
    t.boolean  "unskilled",                                                           :default => false
    t.string   "facebook_session"
    t.integer  "default_reminder",                                                    :default => 1
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["facebook_uid"], :name => "index_users_on_facebook_uid"
  add_index "users", ["id", "confirmation_token"], :name => "index_users_on_id_and_confirmation_token"
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

  create_table "vids", :force => true do |t|
    t.integer  "vidable_id"
    t.string   "vidable_type"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "caption"
    t.integer  "position"
  end

end
