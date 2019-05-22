class AddNotificationToken < ActiveRecord::Migration
  def change
    create_table :notification_tokens do |t|
      t.string :device_token
      t.boolean :enabled
      t.integer :user_id
      t.string :device_description

      t.timestamps null: false

      add_index :notification_tokens, ["user_id"], name: "index_notification_tokens_on_user_id", unique: false
      add_index :api_keys, ["device_token"], name: "index_notification_tokens_on_device_token", unique: true
    end
  end
end