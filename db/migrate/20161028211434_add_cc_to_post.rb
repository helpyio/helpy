class AddCcToPost < ActiveRecord::Migration
  def change
    add_column :posts, :cc, :string
    add_column :posts, :bcc, :string
  end
end
