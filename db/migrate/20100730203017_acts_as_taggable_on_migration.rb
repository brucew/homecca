class ActsAsTaggableOnMigration < ActiveRecord::Migration
  require 'acts-as-taggable-on'
  def self.up
#    create_table :tags do |t|
#      t.column :name, :string
#    end

    add_column :taggings, :tagger_id, :integer
    add_column :taggings, :tagger_type, :string
    add_column :taggings, :context, :string

#    create_table :taggings do |t|
#      t.column :tag_id, :integer
#      t.column :taggable_id, :integer
#      t.column :tagger_id, :integer
#      t.column :tagger_type, :string
#
      # You should make sure that the column created is
      # long enough to store the required class names.
#      t.column :taggable_type, :string
#      t.column :context, :string
#
#      t.column :created_at, :datetime
#    end

#    add_index :taggings, :tag_id
    remove_index :taggings, [:taggable_id, :taggable_type]
    add_index :taggings, [:taggable_id, :taggable_type, :context]

    Tagging.all.each do |tag|
      tag.update_attribute(:context, 'tags')
    end
  end

  def self.down
    remove_index :taggings, [:taggable_id, :taggable_type, :context]
    add_index :taggings, [:taggable_id, :taggable_type]
    remove_column :taggings, :tagger_id
    remove_column :taggings, :tagger_type
    remove_column :taggings, :context
#    drop_table :taggings
#    drop_table :tags
  end
end
