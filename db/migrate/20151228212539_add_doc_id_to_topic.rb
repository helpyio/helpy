class AddDocIdToTopic < ActiveRecord::Migration
  def change
    add_column :topics, :doc_id, :integer, default: 0
    add_column :docs, :topics_count, :integer, default: 0
    add_column :docs, :allow_comments, :boolean, default: true
  end
end
