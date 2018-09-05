# This migration comes from helpy_cloud_engine (originally 20170614015944)
class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :topic_id, index: true
      t.integer :score
      t.text :comments
      t.integer :user_id, index: true

      t.timestamps null: false
    end
  end
end
