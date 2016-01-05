class AddDocIdToTopic < ActiveRecord::Migration
#def change
#    add_column :topics, :doc_id, :integer, default: 0
#    add_column :docs, :topics_count, :integer, default: 0
#    add_column :docs, :allow_comments, :boolean, default: true

#    Forum.create(name: 'Doc comments', private: true)
#  end

  def up
    add_column :topics, :doc_id, :integer, default: 0
    add_column :docs, :topics_count, :integer, default: 0
    add_column :docs, :allow_comments, :boolean, default: true

    if Forum.where(name: 'Doc comments').nil?
      f = Forum.create(name: 'Doc comments', description: 'Contains comments to docs', private: true)
      f.save
    end
  end

  def down
    remove_column :topics, :doc_id
    remove_column :docs, :topics_count
    remove_column :docs, :allow_comments

    Forum.where(name: 'Doc comments').first.destroy
  end

end
