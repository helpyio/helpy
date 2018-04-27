class AddPublicToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :visibility, :string, default: 'all'
  end
end
