# This migration comes from helpy_cloud_engine (originally 20170119003113)
class AddFieldsToTopics < ActiveRecord::Migration
  change_table :topics do |t|
    t.string   :condition, default: 'green'
    t.string   :sentiment
    t.datetime   :last
  end

end
