module Group
  class ConversationChannel < ApplicationCable::Channel
    def subscribed
      stream_from "group_conversations_#{current_user.id}"
    end

    def unsubscribed
      stop_all_streams
    end
  end
end
