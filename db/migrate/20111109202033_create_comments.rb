class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.text :body
      t.belongs_to :commenter
      t.belongs_to :commentable, :polymorphic => true

      t.timestamps
    end
  end

  def self.down
    #drop_table :comments
  end
end
