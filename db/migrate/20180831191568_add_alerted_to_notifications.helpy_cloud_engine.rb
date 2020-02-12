# This migration comes from helpy_cloud_engine (originally 20180620192924)
class AddAlertedToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :alerted_at, :datetime
  end
end
