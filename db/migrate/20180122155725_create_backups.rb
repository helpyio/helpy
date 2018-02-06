class CreateBackups < ActiveRecord::Migration
  def change
    create_table :backups do |t|
      t.integer :user_id, index: true
      t.text :csv
      t.string :model
      t.string :csv_name

      t.timestamps null: false
    end
  end
end
