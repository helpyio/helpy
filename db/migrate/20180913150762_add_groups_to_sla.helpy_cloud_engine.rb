# This migration comes from helpy_cloud_engine (originally 20180814025543)
class AddGroupsToSla < ActiveRecord::Migration
  def change
    add_column :slas, :selected_groups, :string, array: true
    add_column :slas, :selected_ticket_priorities, :string, array: true
    add_column :slas, :selected_user_priorities, :string, array: true
  end
end
