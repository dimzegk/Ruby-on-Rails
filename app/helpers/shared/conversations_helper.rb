module Shared::ConversationsHelper
  def group_conv_seen_status(conversation, current_user)
    return "" if current_user.nil?

    last_message = conversation.messages.last
    return "" if last_message.nil?

    not_created_by_user = last_message.user_id != current_user.id
    seen_by_user = !last_message.seen_by.include?(current_user.id)

    not_created_by_user && seen_by_user ? "unseen-conv" : ""
  end
end
