class AddPriorityToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :priority, :integer, default: 1

    add_index :topics, :priority
  end
end
