class Private::MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message, previous_message)
    sender    = message.respond_to?(:user) ? message.user : message.sender
    recipient = message.conversation.opposed_user(sender)

    previous_message ||= message.conversation.messages
                             .where("created_at < ?", message.created_at)
                             .order(created_at: :desc).first


    ActionCable.server.broadcast(
      "private_conversations_#{recipient.id}",
      action: "append_message",
      recipient: true,
      conversation_id: message.conversation_id,
      message: render_message(message, previous_message, user: recipient),
      sender_info: { id: sender.id, name: sender.try(:name) }
    )


    ActionCable.server.broadcast(
      "private_conversations_#{sender.id}",
      action: "append_message",
      recipient: false,
      conversation_id: message.conversation_id,
      message: render_message(message, previous_message, user: sender)
    )
  end

  private

  def render_message(message, previous_message, user:)
    ApplicationController.render(
      partial: "private/messages/message",
      formats: [ :html ],
      locals: { message: message, previous_message: previous_message, user: user }
    )
  end
end
