# This migration comes from helpy_cloud_engine (originally 20180726172432)
class CreateSlas < ActiveRecord::Migration
  def change
    create_table :slas do |t|
      t.string :name
      t.text :description
      t.string :event
      t.string :priority
      t.integer :time
      t.integer :time_units
      t.integer :minutes
      t.string :tags
      t.string :group
      t.integer :assigned_user_id
      t.text :note
      t.string :notify_users, array: true
      t.boolean :active

      t.timestamps null: false
    end
  end
end
