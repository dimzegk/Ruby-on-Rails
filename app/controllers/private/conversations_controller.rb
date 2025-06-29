module Private
  class ConversationsController < ApplicationController
    before_action :authenticate_user!
    include PostsHelper

    def create
      post = Post.find(params[:post_id])
      recipient_id = post.user.id

      conversation = Private::Conversation.new(
        sender_id: current_user.id,
        recipient_id: recipient_id
      )

if conversation.save
  Private::Message.create(
    sender_id: current_user.id,
    conversation_id: conversation.id,
    body: params[:message_body]
  )

  @post = post
  @message_has_been_sent = true

  respond_to do |format|
    format.turbo_stream do
      render turbo_stream: turbo_stream.replace(
        "contact_user",
        partial: "posts/show/contact_user/message_form/message_sent"
      )
    end
  end

end
    end
  end
end
