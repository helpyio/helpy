class AddVotingTogglesToForums < ActiveRecord::Migration
  def change
    add_column :forums, :allow_topic_voting, :boolean, default: false
    add_column :forums, :allow_post_voting, :boolean, default: false
  end
end
