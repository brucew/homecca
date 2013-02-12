class RenameToCreatedBy < ActiveRecord::Migration
  def self.up
    rename_column :comments, :commenter_id, :created_by_id
    add_column :articles, :created_by_id, :integer
    change_column :articles, :state, :string, :default => :draft
  end

  def self.down
  end
end
