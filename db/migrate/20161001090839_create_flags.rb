class CreateFlags < ActiveRecord::Migration
  def change
    create_table :flags do |t|
      t.integer :post_id
      t.integer :generated_topic_id
      t.text :reason

      t.timestamps null: false
    end
  end
end
