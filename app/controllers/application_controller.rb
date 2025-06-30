class ApplicationController < ActionController::Base
include Gon::ControllerHelpers
    before_action :opened_conversations_windows
  allow_browser versions: :modern
  def redirect_if_not_signed_in
    redirect_to root_path if !user_signed_in?
  end

  def redirect_if_signed_in
    redirect_to root_path if user_signed_in?
  end
  before_action :authenticate_user!
  helper_method :user_signed_in?, :current_user
  def opened_conversations_windows
  if user_signed_in?
    # opened conversations
    session[:private_conversations] ||= []
    @private_conversations_windows = Private::Conversation.includes(:recipient, :messages)
                                      .find(session[:private_conversations])
  else
    @private_conversations_windows = []
  end
end
end
