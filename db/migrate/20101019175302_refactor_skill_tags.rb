class RefactorSkillTags < ActiveRecord::Migration
  def self.up
    providers = Provider.all
    providers.each do |p|
      p.update_attribute(:skills, p.skills)
    end

    requests = Request.all
    requests.each do |r|
      r.update_attribute(:skills, r.skills)
    end
  end

  def self.down
  end
end
