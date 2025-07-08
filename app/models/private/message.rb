module Private
  class Message < ApplicationRecord
    self.table_name = "private_messages"
    belongs_to :conversation,
               class_name: "Private::Conversation",
               foreign_key: :conversation_id
   belongs_to :sender,
           class_name: "User",
           foreign_key: :sender_id
  end
    after_create_commit do
    Private::MessageBroadcastJob.perform_later(self, previous_message)
  end

  def previous_message
    index = conversation.messages.index(self)
    conversation.messages[index - 1] if index && index > 0
  end
end
