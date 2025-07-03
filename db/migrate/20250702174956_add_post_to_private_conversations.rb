class AddPostToPrivateConversations < ActiveRecord::Migration[8.0]
  def change
    add_reference :private_conversations, :post, foreign_key: true
  end
end
