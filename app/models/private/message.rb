module Private
  class Message < ApplicationRecord
    self.table_name = "private_messages"
    belongs_to :conversation,
               class_name: "Private::Conversation",
               foreign_key: :conversation_id
    belongs_to :user
  end
end
