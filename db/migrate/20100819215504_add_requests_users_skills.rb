class AddRequestsUsersSkills < ActiveRecord::Migration
  def self.up
    add_column :requests, :skills, :string
    add_column :users, :skills, :string
    reqs = Request.all
    reqs.each do |req|
      req.skills = req.tag_list.to_s
      req.save
    end
    ps = Provider.all
    ps.each do |p|
      p.skills = p.tag_list.to_s
      p.save
    end
  end

  def self.down
    remove_column :requests, :skills
    remove_column :users, :skills
  end
end
