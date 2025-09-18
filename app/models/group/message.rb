module Group
  class Message < ApplicationRecord
    self.table_name = "group_messages"

    belongs_to :conversation,
               class_name: "Group::Conversation",
               foreign_key: :conversation_id

    belongs_to :user,  
               class_name: "User",
               foreign_key: :user_id

    after_create_commit do
      Group::MessageBroadcastJob.perform_later(self, previous_message)
    end

    def previous_message
      index = conversation.messages.index(self)
      conversation.messages[index - 1] if index && index > 0
    end
  end
end
