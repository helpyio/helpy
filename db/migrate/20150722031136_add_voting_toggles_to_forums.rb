class AddVotingTogglesToForums < ActiveRecord::Migration
  def change
    add_column :posts, :points, :integer, default: 0
    add_column :forums, :allow_topic_voting, :boolean, default: false
    add_column :forums, :allow_post_voting, :boolean, default: false
    add_column :forums, :layout, :string, default: 'table'
  end
end
