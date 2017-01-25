class AddToUsers < ActiveRecord::Migration
  def change
    add_column :users, :priority, :string, default: 'normal'
    add_index :users, :priority
  end
end
