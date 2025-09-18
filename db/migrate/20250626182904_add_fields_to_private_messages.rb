class AddFieldsToPrivateMessages < ActiveRecord::Migration[6.1]
  def change
    add_column :private_messages, :body, :text
    add_column :private_messages, :sender_id, :integer
    add_column :private_messages, :conversation_id, :integer
    add_column :private_messages, :seen, :boolean, default: false

    add_foreign_key :private_messages, :users, column: :sender_id
    add_foreign_key :private_messages, :private_conversations, column: :conversation_id
  end
end
