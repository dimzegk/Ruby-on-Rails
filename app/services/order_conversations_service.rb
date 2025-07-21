class OrderConversationsService
  def initialize(params)
    @user = params[:user]
  end

  def call
    Private::Conversation
      .all_by_user(@user.id)
      .includes(:messages)
      .reject(&:nil?)
      .select { |c| c.sender && c.recipient } # απορρίπτει αν λείπει sender/recipient
      .sort_by { |c| c.messages.last&.created_at || Time.at(0) }
      .reverse
  end
end
