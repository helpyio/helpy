# This migration comes from helpy_cloud_engine (originally 20180820222513)
class AddHoursToSlas < ActiveRecord::Migration
  def change
    add_column :slas, :set_hours, :boolean, default: false
    add_column :slas, :monday_active, :boolean, default: false
    add_column :slas, :monday_start, :integer, default: 9
    add_column :slas, :monday_end, :integer, default: 18
    add_column :slas, :tuesday_active, :boolean, default: false
    add_column :slas, :tuesday_start, :integer, default: 9
    add_column :slas, :tuesday_end, :integer, default: 18
    add_column :slas, :wednesday_active, :boolean, default: false
    add_column :slas, :wednesday_start, :integer, default: 9
    add_column :slas, :wednesday_end, :integer, default: 18
    add_column :slas, :thursday_active, :boolean, default: false
    add_column :slas, :thursday_start, :integer, default: 9
    add_column :slas, :thursday_end, :integer, default: 18
    add_column :slas, :friday_active, :boolean, default: false
    add_column :slas, :friday_start, :integer, default: 9
    add_column :slas, :friday_end, :integer, default: 18
    add_column :slas, :saturday_active, :boolean, default: false
    add_column :slas, :saturday_start, :integer, default: 9
    add_column :slas, :saturday_end, :integer, default: 18
    add_column :slas, :sunday_active, :boolean, default: false
    add_column :slas, :sunday_start, :integer, default: 9
    add_column :slas, :sunday_end, :integer, default: 18
  end
end
