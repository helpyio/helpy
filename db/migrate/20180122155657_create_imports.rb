class CreateImports < ActiveRecord::Migration
  def change
    create_table :imports do |t|
      t.string :status
      t.string :notes
      t.string :model
      t.datetime :started_at
      t.datetime :completed_at
      t.integer :submited_record_count
      t.text :imported_ids
      t.text :error_log

      t.timestamps null: false
    end
  end

end
