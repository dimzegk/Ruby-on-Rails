
module Group
  class MessagesController < ApplicationController
    before_action :authenticate_user!
    include Messages

    def index
      get_messages("group", 10)
      @user = current_user
      @is_messenger = params[:is_messenger]
      render partial: "group/messages/load_more_messages", formats: [:js]
    end

    def create
      @conversation = Group::Conversation.find(params[:conversation_id])

      text = params.dig(:message, :body).presence ||
             params[:body].presence ||
             params[:content].presence

      if text.blank?
        respond_to do |f|
          f.turbo_stream { head :unprocessable_entity }
          f.html         { redirect_back fallback_location: messenger_path, alert: "Empty message" }
          f.json         { render json: { ok: false, error: "Empty message" }, status: :bad_request }
        end
        return
      end

      @message = @conversation.messages.build(content: text, user: current_user)

      if @message.save
        assoc = @conversation.respond_to?(:users) ? :users : :members
        Array(@conversation.public_send(assoc)).each do |u|
          Turbo::StreamsChannel.broadcast_append_to(
            "u#{u.id}:gc#{@conversation.id}",
            target:  "gc#{@conversation.id}-messages_ul",
            partial: "group/messages/message/message",
            locals:  { message: @message, user: u }
          )
        end

        respond_to do |f|
          f.turbo_stream  
          f.html { redirect_to messenger_path(anchor: "gc#{@conversation.id}") }
          f.json { render json: { ok: true }, status: :ok }
        end
      else
        respond_to do |f|
          f.turbo_stream { head :unprocessable_entity }
          f.html { redirect_back fallback_location: messenger_path, alert: @message.errors.full_messages.to_sentence }
          f.json { render json: { ok: false, errors: @message.errors.full_messages }, status: :unprocessable_entity }
        end
      end
    rescue => e
      Rails.logger.error("[Group::Messages#create] #{e.class}: #{e.message}")
      respond_to do |f|
        f.turbo_stream { head :internal_server_error }
        f.html { redirect_back fallback_location: messenger_path, alert: "Server error" }
        f.json { render json: { ok: false, error: "Server error" }, status: :internal_server_error }
      end
    end
  end
end
