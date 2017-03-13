class AddColumnsToTag < ActiveRecord::Migration
  def change
    add_column :tags, :show_on_helpcenter, :boolean, :default => false
    add_column :tags, :show_on_admin, :boolean, :default => false
    add_column :tags, :show_on_dashboard, :boolean, :default => false
  end
end
