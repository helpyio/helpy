# This migration comes from helpy_cloud_engine (originally 20170321204748)
class CreateBoxes < ActiveRecord::Migration
  def change
    create_table :boxes do |t|
      t.string :label
      t.string :name
      t.text :description
      t.integer :rank
      t.text :query
      t.boolean :default

      t.timestamps null: false
    end
  end
end
