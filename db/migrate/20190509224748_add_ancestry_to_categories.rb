class AddAncestryToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :ancestry, :string
    add_index :categories, :ancestry
  end
end
