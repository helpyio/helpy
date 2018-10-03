# This migration comes from helpy_cloud_engine (originally 20180125020529)
class AddCounterToDocs < ActiveRecord::Migration
  def change
    add_column :docs, :doc_views_count, :integer, default: 0
  end
end
