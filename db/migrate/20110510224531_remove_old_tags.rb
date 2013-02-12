class RemoveOldTags < ActiveRecord::Migration
  def self.up
    rename_column :users, :skills, :xxx_skills
    providers = Provider.all
    providers.each do |provider|
      provider.about = provider.about + "\n\nSkills:\n" + provider.xxx_skills
      provider.save
    end

    Tagging.delete_all
    Tag.delete_all
  end

  def self.down
  end
end
