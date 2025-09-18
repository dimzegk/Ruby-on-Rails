class Group::MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message, previous_message)
    conversation = message.conversation
    previous_message ||= conversation.messages
                                    .where("created_at < ?", message.created_at)
                                    .order(created_at: :desc)
                                    .first

    conversation.users.find_each do |u|
      ActionCable.server.broadcast(
        "group_conversations_#{u.id}",
        action: "append_message",
        conversation_id: conversation.id,
        message: ApplicationController.render(
          partial: "group/messages/message",
          formats: [ :html ],
          locals: { message: message, previous_message: previous_message, user: u }
        )
      )
    end
  end
end
