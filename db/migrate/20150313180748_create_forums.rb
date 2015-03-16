class CreateForums < ActiveRecord::Migration
  def change
    create_table :forums do |t|
      t.string :name
      t.text :description
      t.integer :topics_count, :default => 0, :null => false
      t.datetime :last_post_date
      t.integer :last_post_id
      t.boolean :private, :default => false

      t.timestamps null: false
    end
  end
end
