class AddChannelToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :channel, :string, default: 'email'
  end
end
