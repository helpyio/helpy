class AddCountryToUsers < ActiveRecord::Migration
  def up
    add_column(:users, :country, :string)
  end

  # rake db:migrate:down VERSION=20170519164505
  def down
    remove_column(:users, :country)
  end
end
