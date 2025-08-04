class MessengersController < ApplicationController
  before_action :authenticate_user!  # ή redirect_if_not_signed_in αν έχεις helper

  def index
    @users = User.where.not(id: current_user.id)
    @group_conversations = current_user.group_conversations
  end

  # fetch & render a private conversation inside messenger
  def get_private_conversation
    conversation = Private::Conversation.between_users(current_user.id, params[:id])
    @conversation = conversation.first
    respond_to do |format|
      format.js { render "get_private_conversation" }
    end
  end

  # fetch & render a group conversation inside messenger
  def get_group_conversation
    @conversation = Group::Conversation.find(params[:group_conversation_id])
    respond_to do |format|
      format.js { render "get_group_conversation" }
    end
  end

  # optional: open via a single endpoint based on params[:type]
  def open_messenger
    @type = params[:type]
    @conversation = get_conversation
    render :index
  end

  private

  def get_conversation
    ConversationForMessengerService.new(
      conversation_type: params[:type],             # 'private' | 'group'
      user1_id: current_user.id,
      user2_id: params[:id],                        # recipient id (για private)
      group_conversation_id: params[:group_conversation_id]
    ).call
  end
end
