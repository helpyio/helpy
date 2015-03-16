class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.integer :rank
      t.boolean :active, :default => true
      t.string :link
      t.string :section

      t.timestamps null: false
    end
  end
end
