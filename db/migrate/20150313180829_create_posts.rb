class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :topic_id
      t.integer :user_id
      t.text :body
      t.string :kind #reply or first, note
      t.boolean :active, :default => true

      t.timestamps null: false
    end
  end
end
