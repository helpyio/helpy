# This migration comes from helpy_cloud_engine (originally 20161206033447)
class CreateTopicFields < ActiveRecord::Migration
  def change
    create_table :topic_fields do |t|
      t.string :name
      t.string :label
      t.string :field_type
      t.string :select_options
      t.boolean :required
      t.string :class_names
      t.integer :rank
      t.string :group
      t.string :toggle_target
      t.boolean :display_on_helpcenter
      t.boolean :display_on_admin

      t.timestamps null: false
    end
  end
end
