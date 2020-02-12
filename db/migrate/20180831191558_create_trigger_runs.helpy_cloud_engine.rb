# This migration comes from helpy_cloud_engine (originally 20170108180451)
class CreateTriggerRuns < ActiveRecord::Migration
  def change
    create_table :trigger_runs do |t|
      t.integer :topic_id
      t.integer :trigger_id
      # t.index :topic_trigger, [:topic_id, :trigger_id]

      t.timestamps null: false
    end
  end
end
