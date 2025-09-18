class ApplicationController < ActionController::Base
  include Gon::ControllerHelpers

  before_action :authenticate_user!
  before_action :opened_conversations_windows
  before_action :all_ordered_conversations
  before_action :set_user_data

  allow_browser versions: :modern

  helper_method :user_signed_in?, :current_user

  def redirect_if_not_signed_in
    redirect_to root_path unless user_signed_in?
  end

  def redirect_if_signed_in
    redirect_to root_path if user_signed_in?
  end

  private
def set_user_data
    if user_signed_in?
      gon.group_conversations = current_user.group_conversations.ids
      gon.user_id = current_user.id
      cookies[:user_id] = current_user.id if current_user.present?
      cookies[:group_conversations] = current_user.group_conversations.ids
    else
      gon.group_conversations = []
    end
  end
def opened_conversations_windows
  if user_signed_in?
    session[:private_conversations] ||= []
    session[:group_conversations] ||= []

    @private_conversations_windows = Private::Conversation
                                        .includes(:recipient, :messages)
                                        .find(session[:private_conversations])

    @group_conversations_windows = Group::Conversation
                                       .includes(:messages)
                                       .find(session[:group_conversations])
  else
    @private_conversations_windows = []
    @group_conversations_windows = []
  end
end

def messenger_page?
    controller_name == "messengers"
  end
  def all_ordered_conversations
    if user_signed_in?
      @all_conversations = OrderConversationsService.new(user: current_user).call
    end
  end
end
