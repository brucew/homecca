class AddUsersThumbnails < ActiveRecord::Migration
  def self.up
    users = User.all
    users.each do |user|
      user.avatar.reprocess!
    end
  end

  def self.down
  end
end
