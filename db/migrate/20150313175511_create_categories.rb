class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.string :icon
      t.string :keywords
      t.string :title_tag
      t.string :meta_description
      t.integer :rank
      t.boolean :front_page, :default => false
      t.boolean :active, :default => true
      t.string :permalink
      t.string :section

      t.timestamps null: false
    end
  end
end
