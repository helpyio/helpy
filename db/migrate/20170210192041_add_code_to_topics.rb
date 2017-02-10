class AddCodeToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :code, :string
    add_index :topics, :code
  end
end
