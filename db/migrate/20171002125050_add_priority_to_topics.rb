class AddPriorityToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :priority, :string, default: 'normal'

    add_index :topics, :priority
  end
end
