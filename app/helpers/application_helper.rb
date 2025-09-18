# app/helpers/application_helper.rb
module ApplicationHelper
  include PostsHelper
  include Private::ConversationsHelper
  include Private::MessagesHelper
  include Shared::MessagesHelper
  include Group::ConversationsHelper
  include Group::MessagesHelper

  # Είμαστε στη σελίδα του messenger;
  def on_messenger_page?
    controller_path == "messengers" # ή controller_name == "messengers"
  end

  # Αν είμαστε στο messenger -> άδειες λίστες για να ΜΗ γίνει render κανένα window
  def private_conversations_windows
    on_messenger_page? ? [] : Array(@private_conversations_windows)
  end

  def group_conversations_windows
    on_messenger_page? ? [] : Array(@group_conversations_windows)
  end
  def messenger_page?
    controller.controller_name == "messengers"
  end
  def profile_link_path
    return profile_path if respond_to?(:profile_path) rescue nil

    return user_path(current_user) if respond_to?(:user_path) && current_user

    return account_path if respond_to?(:account_path)
    nil
  end

  def settings_link_path
    return settings_path if respond_to?(:settings_path) rescue nil
    return edit_user_registration_path if respond_to?(:edit_user_registration_path) # Devise
    nil
  end
end
