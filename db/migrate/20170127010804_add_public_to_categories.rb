class AddPublicToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :public, :boolean, default: true
  end
end
