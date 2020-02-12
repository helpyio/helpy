# This migration comes from helpy_cloud_engine (originally 20180206221622)
class CreateFollowers < ActiveRecord::Migration
  def change
    create_table :followers do |t|
      t.integer :user_id
      t.integer :topic_id

      t.timestamps null: false
    end
    add_index :followers, :user_id
    add_index :followers, :topic_id
  end
end
