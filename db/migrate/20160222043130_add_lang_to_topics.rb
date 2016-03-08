class AddLangToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :locale, :string#, default: 'en'
  end
end
