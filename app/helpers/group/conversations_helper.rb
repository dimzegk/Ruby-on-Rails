module Group::ConversationsHelper
  def contacts_except_recipient(recipient)
    contacts = current_user.all_active_contacts
    contacts.delete_if { |contact| contact.id == recipient.id }
  end
  def add_people_to_group_conv_list(conversation)
    contacts = current_user.all_active_contacts
    users_in_conv = conversation.users
    add_people_to_conv_list = []
    contacts.each do |contact|

      if !users_in_conv.include?(contact)
        add_people_to_conv_list << contact
      end
    end
    add_people_to_conv_list
  end
   def load_group_messages_partial_path(conversation)
    if conversation.messages.count > 0
      "group/conversations/conversation/messages_list/load_messages"
    else
      "shared/empty_partial"
    end
  end
end
