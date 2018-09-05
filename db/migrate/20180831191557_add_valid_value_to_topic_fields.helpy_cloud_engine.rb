# This migration comes from helpy_cloud_engine (originally 20161207213340)
class AddValidValueToTopicFields < ActiveRecord::Migration
  def change
    add_column :topic_fields, :valid_value, :string
  end
end
