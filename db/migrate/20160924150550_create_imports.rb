class CreateImports < ActiveRecord::Migration
  def change
    create_table :imports do |t|
      t.string :status
      t.string :notes
      t.string :model

      t.timestamps null: false
    end
  end
end
