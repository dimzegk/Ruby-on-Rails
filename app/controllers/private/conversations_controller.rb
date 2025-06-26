module Private
  class ConversationsController < ApplicationController
    before_action :authenticate_user!

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

        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace(
              "contact_user",
              partial: "posts/show/contact_user/already_in_touch"
            )
          end
        end
      else
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace(
              "contact_user",
              partial: "posts/show/contact_user/message_form/fail"
            )
          end
        end
      end
    end
  end
end
