# This migration comes from helpy_cloud_engine (originally 20180828154601)
class AddTzToSla < ActiveRecord::Migration
  def change
    add_column :slas, :time_zone, :string, default: 'UTC'
  end
end
