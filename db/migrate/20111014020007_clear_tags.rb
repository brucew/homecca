class ClearTags < ActiveRecord::Migration
  def self.up
    drop_table :tags

    drop_table :taggings

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
    add_index "taggings", ["taggable_id", "taggable_type", "context"],
              :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

    create_table "tags", :force => true do |t|
      t.string "name"
    end

  end

  def self.down
  end
end
