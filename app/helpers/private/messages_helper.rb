module Private::MessagesHelper
include Shared::MessagesHelper

 def private_message_date_check(message, previous_message)
    if defined?(previous_message) && previous_message.present?
      if previous_message.created_at.to_date != message.created_at.to_date
        @message = message
        "private/messages/message/new_date"
      else
        "shared/empty_partial"
      end
    else
      "shared/empty_partial"
    end
  end

  def sent_or_received(message, user)
    user.id == message.sender_id ? "message-sent" : "message-received"
  end

  def seen_or_unseen(message)
    message.seen == false ? "unseen" : ""
  end
  def replace_link_to_private_messages_partial_path
  "private/messages/load_more_messages/window/replace_link_to_messages"
end
  def system_message?(message)
    return true if message.respond_to?(:system?) && message.system?
    return true if message.respond_to?(:kind) && message.kind.to_s == "system"
    return true if message.respond_to?(:user_id) && message.user_id.blank?

    body = message.respond_to?(:body) ? message.body.to_s : ""
    body.match?(/\b(added by|removed by|invited|joined|left)\b/i)
  end
end
