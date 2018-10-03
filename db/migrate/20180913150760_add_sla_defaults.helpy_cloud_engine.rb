# This migration comes from helpy_cloud_engine (originally 20180803152813)
class AddSlaDefaults < ActiveRecord::Migration
  def change
    change_column_default :slas, :active, true
    change_column_default :slas, :time_units, 60
  end
end
