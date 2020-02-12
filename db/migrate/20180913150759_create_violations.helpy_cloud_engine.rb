# This migration comes from helpy_cloud_engine (originally 20180802155413)
class CreateViolations < ActiveRecord::Migration
  def change
    create_table :violations do |t|
      t.integer :topic_id
      t.integer :sla_id
      t.boolean :active

      t.timestamps null: false
    end
  end
end
