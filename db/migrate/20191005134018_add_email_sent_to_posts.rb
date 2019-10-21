class AddEmailSentToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :email_to_address, :string, default: ''
  end
end
