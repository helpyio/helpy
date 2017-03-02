class AddFieldsToTag < ActiveRecord::Migration
  def change
    add_column :tags, :description, :text
    add_column :tags, :color, :string
    add_column :tags, :active, :boolean, default: true
  end
end
