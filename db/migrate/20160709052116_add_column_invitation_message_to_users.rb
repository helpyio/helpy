class AddColumnInvitationMessageToUsers < ActiveRecord::Migration
  def change
    add_column :users, :invitation_message, :text
  end
end
