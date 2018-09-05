# This migration comes from helpy_cloud_engine (originally 20161201181611)
class CreateTriggers < ActiveRecord::Migration
  def change
    create_table :triggers do |t|
      t.string :name
      t.string :mode, default: 'and' # or
      t.text :actions
      t.text :conditions
      t.string :url
      t.string :event
      t.string :slack_channel
      t.boolean :active, default: true
      t.integer :rank

      t.timestamps null: false
    end
  end
end
