class BlueLightSpecialUpdateUsersTo020 < ActiveRecord::Migration
  def self.up
    change_table(:users) do |t|
      t.string :first_name, :limit => 50
      t.string :last_name, :limit => 50
      t.string :role, :limit => 50
      t.string :facebook_uid, :limit => 50
      t.string :password_reset_token, :limit => 128
    end

    add_index :users, :facebook_uid
  end

  def self.down
    change_table(:users) do |t|
      t.remove :first_name,:last_name,:role,:facebook_uid,:password_reset_token
    end
  end
end
