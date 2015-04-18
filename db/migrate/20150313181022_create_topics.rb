class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.integer :forum_id
      t.integer :user_id
      t.string :name
      t.integer :posts_count, :default => 0, :null => false
      t.string :waiting_on
      t.datetime :last_post_date
      t.datetime :closed_date
      t.integer :last_post_id
      t.string :status, :default => "new"
      t.boolean :private, :default => false
      t.integer :assigned_user_id, :default => 2
      t.boolean :cheatsheet, :default => false
      t.integer :points, :default => 0
      t.text :post_cache

      t.timestamps null: false
    end
  end
end
