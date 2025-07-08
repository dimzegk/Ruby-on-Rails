module Private
  class ConversationChannel < ApplicationCable::Channel
    def subscribed
      stream_from "private_conversations_#{current_user.id}"
    end

    def unsubscribed
      stop_all_streams
    end
    def received(data)
  logger.debug "📩 SERVER Received: #{data.inspect}"
end
  end
end
