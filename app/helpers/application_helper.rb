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
end
