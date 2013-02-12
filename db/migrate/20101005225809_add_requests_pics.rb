class AddRequestsPics < ActiveRecord::Migration
  def self.up
    add_column :requests, :pic1_file_name,    :string
    add_column :requests, :pic1_content_type, :string
    add_column :requests, :pic1_file_size,    :integer
    add_column :requests, :pic1_updated_at,   :datetime
    add_column :requests, :pic2_file_name,    :string
    add_column :requests, :pic2_content_type, :string
    add_column :requests, :pic2_file_size,    :integer
    add_column :requests, :pic2_updated_at,   :datetime
    add_column :requests, :pic3_file_name,    :string
    add_column :requests, :pic3_content_type, :string
    add_column :requests, :pic3_file_size,    :integer
    add_column :requests, :pic3_updated_at,   :datetime
    add_column :requests, :pic4_file_name,    :string
    add_column :requests, :pic4_content_type, :string
    add_column :requests, :pic4_file_size,    :integer
    add_column :requests, :pic4_updated_at,   :datetime
  end

  def self.down
    remove_column :requests, :pic1_file_name
    remove_column :requests, :pic1_content_type
    remove_column :requests, :pic1_file_size
    remove_column :requests, :pic1_updated_at
    remove_column :requests, :pic2_file_name
    remove_column :requests, :pic2_content_type
    remove_column :requests, :pic2_file_size
    remove_column :requests, :pic2_updated_at
    remove_column :requests, :pic3_file_name
    remove_column :requests, :pic3_content_type
    remove_column :requests, :pic3_file_size
    remove_column :requests, :pic3_updated_at
    remove_column :requests, :pic4_file_name
    remove_column :requests, :pic4_content_type
    remove_column :requests, :pic4_file_size
    remove_column :requests, :pic4_updated_at
  end
end
