class RenameRequestsSeekerToRequester < ActiveRecord::Migration
  def self.up
    rename_column :requests, :seeker_id, :requester_id
  end

  def self.down
    rename_column :requests, :requester_id, :seeker_id 
  end
end
