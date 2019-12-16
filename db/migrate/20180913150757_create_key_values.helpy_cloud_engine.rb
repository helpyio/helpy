# This migration comes from helpy_cloud_engine (originally 20180709035549)
class CreateKeyValues < ActiveRecord::Migration
  def change
    create_table :key_values do |t|
      t.string :key
      t.text :value
      t.integer :kvable_id
      t.string :kvable_type

      t.timestamps null: false
    end

    add_index :key_values, [:kvable_id, :kvable_type], :name => 'kvable_index'
    add_index :key_values, [:value], :name => 'kv_value_index'
    
  end
end
