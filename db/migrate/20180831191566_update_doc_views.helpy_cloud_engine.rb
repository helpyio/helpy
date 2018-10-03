# This migration comes from helpy_cloud_engine (originally 20180129135837)
class UpdateDocViews < ActiveRecord::Migration
  def change
    add_column :doc_views, :results_found, :integer, default: 0
    remove_column :doc_views, :solved
    remove_column :doc_views, :not_solved
  end
end
