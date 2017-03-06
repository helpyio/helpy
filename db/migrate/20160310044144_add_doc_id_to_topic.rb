class AddDocIdToTopic < ActiveRecord::Migration

  def up
    add_column :topics, :doc_id, :integer, default: 0
    add_column :docs, :topics_count, :integer, default: 0
    add_column :docs, :allow_comments, :boolean, default: true
  end

  def down
    remove_column :topics, :doc_id
    remove_column :docs, :topics_count
    remove_column :docs, :allow_comments
  end

end
