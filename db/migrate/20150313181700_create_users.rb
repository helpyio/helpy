class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :login
      t.string :identity_url
      t.string :name
      t.boolean :admin, :default => false
      t.text :bio
      t.text :signature
      t.string :role, :default => 'user'
      t.string :home_phone
      t.string :work_phone
      t.string :cell_phone
      t.string :company
      t.string :street
      t.string :city
      t.string :state
      t.string :zip
      t.string :title
      t.string :twitter
      t.string :linkedin
      t.string :thumbnail
      t.string :medium_image
      t.string :large_image
      t.string :language, :default => 'en'
      t.integer :assigned_ticket_count, :default => 0
      t.integer :topics_count, :default => 0
      t.boolean :active, :default => true

      t.timestamps null: false
    end
  end
end
