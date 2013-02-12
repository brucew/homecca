class RemoveProviderSkillsAndCachedTagList < ActiveRecord::Migration
  def self.up
    remove_column :users, :xxx_skills
    remove_column :users, :cached_tag_list
  end

  def self.down
    add_column :users, :cached_tag_list, :string
    add_column :users, :xxx_skills, :string
  end
end
