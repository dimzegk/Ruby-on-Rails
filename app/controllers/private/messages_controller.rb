module Private
  class MessagesController < ApplicationController
    before_action :authenticate_user!

    def index
      respond_to do |f|
        f.js           { head :ok }
        f.turbo_stream { head :ok }
        f.html         { head :ok }
      end
    end


    def create
      @conversation = Private::Conversation.find(params[:conversation_id])

      text = params.dig(:message, :body).to_s.strip
      if text.blank?
        respond_to do |f|
          f.turbo_stream { head :unprocessable_entity }
          f.html         { redirect_back fallback_location: messenger_path, alert: "Empty message" }
          f.json         { render json: { error: "Empty message" }, status: :unprocessable_entity }
        end
        return
      end

      msg_klass   = @conversation.messages.klass rescue Private::Message
      columns     = msg_klass.column_names


      text_col =
        if    columns.include?("content") then :content
        elsif columns.include?("body")    then :body
        elsif columns.include?("message") then :message
        elsif columns.include?("text")    then :text
        else nil end


      sender_fk =
        if    columns.include?("user_id")   then :user_id
        elsif columns.include?("sender_id") then :sender_id
        elsif columns.include?("author_id") then :author_id
        else nil end

      attrs = {}
      attrs[text_col] = text if text_col
      attrs[sender_fk] = current_user.id if sender_fk

      @message =
        if sender_fk 
          @conversation.messages.build(attrs)
        else
          m = @conversation.messages.build(attrs)
          if m.respond_to?(:user=)
            m.user = current_user
          elsif m.respond_to?(:sender=)
            m.sender = current_user
          elsif m.respond_to?(:author=)
            m.author = current_user
          else
            raise "No sender column/association on Private::Message (tried user/sender/author)"
          end
          m
        end

      if @message.save
        other = @conversation.respond_to?(:opposed_user) ? @conversation.opposed_user(current_user) : nil
        if other
          Turbo::StreamsChannel.broadcast_append_to(
            "u#{other.id}:pc#{@conversation.id}",
            target:  "pc#{@conversation.id}-messages_ul",
            partial: "private/messages/message",
            locals:  { message: @message, user: other }
          )
        end

        respond_to do |f|
          f.turbo_stream do
            render turbo_stream: [
              turbo_stream.append(
                "pc#{@conversation.id}-messages_ul",
                partial: "private/messages/message",
                locals:  { message: @message, user: current_user }
              ),
              turbo_stream.update("pc#{@conversation.id}-input", "")
            ]
          end
          f.html { redirect_to messenger_path(anchor: "pc#{@conversation.id}") }
          f.json { render json: { ok: true } }
        end
      else
        respond_to do |f|
          f.turbo_stream { head :unprocessable_entity }
          f.html         { redirect_back fallback_location: messenger_path, alert: @message.errors.full_messages.to_sentence }
          f.json         { render json: { errors: @message.errors.full_messages }, status: :unprocessable_entity }
        end
      end
    end
  end
end
