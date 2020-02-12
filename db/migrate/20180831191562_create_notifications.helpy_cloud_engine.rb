# This migration comes from helpy_cloud_engine (originally 20171213195739)
class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :recipient_id
      t.integer :actor_id
      t.datetime :read_at
      t.boolean :send_email, default: false
      t.datetime :sent_at
      t.string :action
      t.string :title
      t.text :message
      t.integer :notifiable_id
      t.string :notifiable_type

      t.timestamps null: false
    end
  end
end
