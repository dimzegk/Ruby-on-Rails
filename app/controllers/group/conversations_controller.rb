class Group::ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_gon_data, only: %i[create open]

  def index
    redirect_to messenger_path, status: :see_other
  end


  def create
    @conversation = Group::Conversation.new(conversation_params)

    ActiveRecord::Base.transaction do
      @conversation.save!

      assoc = @conversation.respond_to?(:users) ? :users : :members
      @conversation.public_send(assoc) << current_user
      @conversation.public_send(assoc) << User.where(id: params[:with]) if params[:with].present?

      @conversation.recalc_name!  # ← φτιάξε τίτλο από μέλη
    end

    respond_to do |f|
      f.turbo_stream
      f.html { redirect_to messenger_path(anchor: "gc#{@conversation.id}"), notice: "Group created." }
    end
  rescue ActiveRecord::RecordInvalid => e
    respond_to do |f|
      f.turbo_stream { head :unprocessable_entity }
      f.html { render plain: e.record.errors.full_messages.to_sentence, status: :unprocessable_entity }
    end
  end


  def update
  Group::AddUserToConversationService.new(
    group_conversation_id: params[:id],
    new_user_id: params.dig(:user, :id),
    added_by_id: params[:added_by]
  ).call

  @conversation = Group::Conversation.find(params[:id])
  @conversation.recalc_name!

  @added_user = User.find_by(id: params.dig(:user, :id))
  @added_by   = current_user

  respond_to do |f|
    f.turbo_stream
    f.html { redirect_back fallback_location: messenger_path(anchor: "gc#{@conversation.id}") }
  end
end


  def open
    @conversation = Group::Conversation.find(params[:id])
    add_to_conversations unless already_added?

    respond_to do |f|
      f.turbo_stream { render "group/conversations/open" }
      f.js           { render partial: "group/conversations/open" }
      f.html         { head :ok }
    end
  end


  def close
    @conversation = Group::Conversation.find(params[:id])

    respond_to do |f|
      f.turbo_stream { render "group/conversations/close" }
      f.js           { render "group/conversations/close", formats: [:js] }
      f.html         { head :ok }
    end
  end

  private

  def conversation_params
    params.require(:group_conversation).permit(:name, :description)
  end

  def set_gon_data
    gon.group_conversations = current_user.group_conversations.pluck(:id)
    gon.user_id = current_user.id
  end

  def add_to_conversations
    session[:group_conversations] ||= []
    session[:group_conversations] << @conversation.id
    session[:group_conversations].uniq!
  end

  def already_added?
    Array(session[:group_conversations]).include?(@conversation.id)
  end
end
