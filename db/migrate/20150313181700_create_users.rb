class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :login
      t.string :identity_url
      t.string :name
      t.boolean :admin, :default => false


      t.timestamps null: false
    end
  end
end
