class SetAllProvidersSkillsOn < ActiveRecord::Migration
  def self.up
    Provider.all.each do |provider|
      provider.skills = Request::JOB_TYPES
      provider.save
    end
  end

  def self.down
  end
end
