class AddSenderAndRecipientToPrivateConversations < ActiveRecord::Migration[8.0]
  def change
    add_column :private_conversations, :sender_id, :integer
    add_column :private_conversations, :recipient_id, :integer
  end
end
