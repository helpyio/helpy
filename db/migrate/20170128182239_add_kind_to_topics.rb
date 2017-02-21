class AddKindToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :kind, :string, default: 'ticket'
    add_index :topics, :kind
  end
end
