class AddEmailToGroups < ActiveRecord::Migration
  def change
    add_column :tags, :email_address, :string
    add_column :tags, :email_name, :string
  end
end
