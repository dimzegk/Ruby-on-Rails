module Group::ConversationsHelper
  def contacts_except_recipient(recipient)
    contacts = current_user.all_active_contacts
    contacts.delete_if { |contact| contact.id == recipient.id }
  end
end
