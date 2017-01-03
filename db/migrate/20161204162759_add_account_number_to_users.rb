class AddAccountNumberToUsers < ActiveRecord::Migration
  def change
    add_column :users, :account_number, :string
  end
end
