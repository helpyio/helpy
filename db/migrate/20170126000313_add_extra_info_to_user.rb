class AddExtraInfoToUser < ActiveRecord::Migration
  def change
    add_column :users, :extra_info, :jsonb
  end
end
