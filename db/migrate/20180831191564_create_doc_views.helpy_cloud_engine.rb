# This migration comes from helpy_cloud_engine (originally 20180124235648)
class CreateDocViews < ActiveRecord::Migration
  def change
    create_table :doc_views do |t|
      t.string :collector_action, default: 'view'
      t.integer :user_id
      t.string :session_id
      t.integer :doc_id
      t.string :doc_title
      t.integer :category_id
      t.string :doc_category
      t.string :search_used
      t.boolean :solved, default: false
      t.boolean :not_solved, default: false
      t.text :referrer

      t.timestamps null: false
    end
    add_index :doc_views, :doc_id
  end
end
