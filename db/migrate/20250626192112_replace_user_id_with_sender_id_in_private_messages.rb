class ReplaceUserIdWithSenderIdInPrivateMessages < ActiveRecord::Migration[7.1]
  def change
    remove_column :private_messages, :user_id, :integer
  end
end
