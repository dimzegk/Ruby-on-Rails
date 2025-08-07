module MessengersHelper
  def conversations_list_item_partial_path(conversation)
    # Αν είναι private conversation
    if conversation.is_a?(Private::Conversation)
      "messengers/index/conversations_list_item/private"
    else
      # Αλλιώς θεωρούμε group conversation
      "messengers/index/conversations_list_item/group"
    end
  end

  def append_previous_messages_partial_path
    # Αν η συνομιλία είναι μέσα στον messenger
    if @is_messenger == "true"
      "shared/load_more_messages/messenger/append_messages"
    else
      "shared/load_more_messages/window/append_messages"
    end
  end

  def replace_link_to_private_messages_partial_path
    if @is_messenger == "true"
      "private/messages/load_more_messages/messenger/replace_link_to_messages"
    else
      "private/messages/load_more_messages/window/replace_link_to_messages"
    end
  end
end
