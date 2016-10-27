class AddAttachments < ActiveRecord::Migration
  def change
    add_column :posts, :attachments, :string, array: true, default: []
    add_column :docs, :attachments, :string, array: true, default: []
    add_column :users, :profile_image, :string
  end
end
