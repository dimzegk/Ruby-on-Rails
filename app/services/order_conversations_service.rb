class OrderConversationsService
  def initialize(params)
    @user = params[:user]
  end

def call
  all_private_conversations = Private::Conversation
                                  .all_by_user(@user.id)
                                  .includes(:messages)

  all_group_conversations = @user.group_conversations.includes(:messages)

  all_conversations = all_private_conversations + all_group_conversations

  # Ταξινόμηση κατά created_at του τελευταίου μηνύματος
  all_conversations.sort do |a, b|
    (b.messages.last&.created_at || Time.zone.at(0)) <=>
    (a.messages.last&.created_at || Time.zone.at(0))
  end
end
end
