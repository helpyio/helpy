class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.integer :forum_id
      t.integer :user_id
      t.string :name
      t.integer :posts_count, :default => 0, :null => false
      t.datetime :last_post_date
      t.integer :last_post_id
      t.string :status, :default => "Open"
      t.boolean :private, :default => false
      t.boolean :cheatsheet, :default => false
      t.integer :points, :default => 0

      t.timestamps null: false
    end
  end
end
