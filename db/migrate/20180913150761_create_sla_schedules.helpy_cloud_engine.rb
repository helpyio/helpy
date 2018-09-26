# This migration comes from helpy_cloud_engine (originally 20180812182608)
class CreateSlaSchedules < ActiveRecord::Migration
  def change
    create_table :sla_schedules do |t|
      t.integer :topic_id
      t.integer :sla_id
      t.integer :post_id
      t.integer :topic_id
      t.datetime :wait_until
      t.datetime :job_run

      t.timestamps null: false
    end
  end
end
