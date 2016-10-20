class AddColumnErrorLogToImports < ActiveRecord::Migration
  def change
    add_column :imports, :error_log, :text
  end
end
