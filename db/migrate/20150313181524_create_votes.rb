class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :points, :default => 1
      t.string :voteable_type
      t.integer :voteable_id
      t.integer :user_id, :default => 0

      t.timestamps null: false
    end
  end
end
