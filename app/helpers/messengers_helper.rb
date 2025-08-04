module MessengersHelper
  def conversations_list_item_partial_path(conversation)
    # Αν είναι private conversation
    if conversation.is_a?(Private::Conversation)
      "messengers/index/conversations_list_item/private"
    else
      # αλλιώς θεωρούμε group conversation
      "messengers/index/conversations_list_item/group"
    end
  end
end
