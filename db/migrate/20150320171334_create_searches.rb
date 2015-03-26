class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :name
      t.text :body
      t.string :search_type
      t.integer :search_id
      t.datetime :last_updated_at
      t.timestamps null: false
    end
  end
end
