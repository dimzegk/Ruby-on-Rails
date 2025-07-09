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
def send_message(data)
  message_params = data["message"].each_with_object({}) do |el, hash|
    hash[el["name"]] = el["value"]
  end

  Private::Message.create(message_params)
end
  end
  def set_as_seen(data)
  conversation = Private::Conversation.find(data["conv_id"].to_i)
  messages = conversation.messages.where(seen: false)
  messages.each { |message| message.update(seen: true) }
end
end
