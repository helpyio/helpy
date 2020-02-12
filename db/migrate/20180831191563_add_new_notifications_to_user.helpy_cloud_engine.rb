# This migration comes from helpy_cloud_engine (originally 20171215161416)
class AddNewNotificationsToUser < ActiveRecord::Migration
  def change
    add_column :users, :notify_on_assignment, :boolean, default: true
    add_column :users, :notify_on_mention, :boolean, default: true
  end
end
