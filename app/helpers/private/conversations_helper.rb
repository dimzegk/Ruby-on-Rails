module Private::ConversationsHelper
  def private_conv_recipient(conversation)
    conversation.opposed_user(current_user)
  end

  def load_private_messages(conversation)
    if conversation.messages.count > 0
      "private/conversations/conversation/messages_list/link_to_previous_messages"
    else
      "shared/empty_partial"
    end
  end

  def private_conv_seen_status(conversation)
    last_message = conversation.messages.last
    if last_message.present? && last_message.sender != current_user && !last_message.seen
      "unseen-conv"
    else
      ""
    end
  end

  def add_to_contacts_partial_path(contact, recipient)
    if recipient_is_contact?(recipient)
      "shared/empty_partial"
    else
      non_contact(contact)
    end
  end

  def conv_heading_class(contact)
    if unaccepted_contact_exists(contact)
      "conversation-heading-full"
    else
      "conversation-heading"
    end
  end

  def get_contact_record(recipient)
  ::Contact.find_by_users(current_user.id, recipient.id)
  end

  def unaccepted_contact_request_partial_path(contact)
    if unaccepted_contact_exists(contact)
      if request_sent_by_user(contact)
        "private/conversations/conversation/request_status/sent_by_current_user"
      else
        "private/conversations/conversation/request_status/sent_by_recipient"
      end
    else
      "shared/empty_partial"
    end
  end

  def not_contact_no_request_partial_path(contact, recipient)
    if !recipient_is_contact?(recipient) && !unaccepted_contact_exists(contact)
      "private/conversations/conversation/request_status/send_request"
    else
      "shared/empty_partial"
    end
  end
def create_group_conv_partial_path(contact)
  if recipient_is_contact?(contact)
    "private/conversations/conversation/heading/create_group_conversation"
  else
    "shared/empty_partial"
  end
end
  private

def extract_id(obj)
  return nil if obj.nil?
  return obj.id if obj.respond_to?(:id)
  return obj[:id] if obj.is_a?(Hash) && obj.key?(:id)
  return obj['id'] if obj.is_a?(Hash) && obj.key?('id')
  return obj if obj.is_a?(Integer)
  nil
end

def recipient_is_contact?(recipient)
  rid = extract_id(recipient)
  return false if rid.nil?

  contacts = Array(current_user.all_active_contacts)
  contact_ids = contacts.map { |c| extract_id(c) }.compact
  contact_ids.include?(rid)
end

  def non_contact(contact)
    if unaccepted_contact_exists(contact)
      "shared/empty_partial"
    else
      "private/conversations/conversation/heading/add_user_to_contacts"
    end
  end

  def unaccepted_contact_exists(contact)
    contact.present? && !contact.accepted
  end

  def request_sent_by_user(contact)
    contact.user_id == current_user.id
  end
end
