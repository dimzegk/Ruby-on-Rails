class MessengersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_all_conversations, only: [ :index, :open_messenger ]
  before_action :no_cache!, only: [ :get_private_conversation, :get_group_conversation ]

  def index
    @users = User.where.not(id: current_user.id)
    @group_conversations = current_user.group_conversations
    @is_messenger = "true"

  end


  def open_messenger
    @type         = params[:type]
    @conversation = get_conversation
    @is_messenger = "true"
    render :index
  end

  def get_private_conversation
    @conversation = Private::Conversation.between_users(current_user.id, params[:id]).first
    @conversation ||= Private::Conversation.create!(sender_id: current_user.id, recipient_id: params[:id])

    respond_to do |f|
      f.js { render "get_private_conversation" }
    end
  end

  def get_group_conversation

    @conversation = current_user.group_conversations.find_by(id: params[:group_conversation_id])
    return head :not_found unless @conversation

    respond_to do |f|
      f.js { render "get_group_conversation" }
    end
  end

  private

  def get_conversation
    ConversationForMessengerService.new(
      conversation_type: params[:type],  
      user1_id: current_user.id,
      user2_id: params[:id],
      group_conversation_id: params[:group_conversation_id]
    ).call
  end

  def set_all_conversations
    @all_conversations = OrderConversationsService.new(current_user).call
  end

  def no_cache!
    response.headers["Cache-Control"] = "no-store, no-cache, must-revalidate, max-age=0, private"
    response.headers["Pragma"]        = "no-cache"
    response.headers["Expires"]       = "0"
  end
end
