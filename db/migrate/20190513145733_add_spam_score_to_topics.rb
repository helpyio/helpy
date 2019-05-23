class AddSpamScoreToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :spam_score, :decimal, default: 0.0
    add_column :topics, :spam_report, :text, default: ""
  end
end
