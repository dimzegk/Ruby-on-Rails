class OrderConversationsService
  def initialize(arg)
    @user =
      if arg.respond_to?(:id)        # π.χ. User instance
        arg
      elsif arg.is_a?(Hash)          # π.χ. { user: current_user }
        arg[:user] || arg["user"]
      end
  end

  def call
    raise ArgumentError, "user is required" unless @user

    all_private = Private::Conversation
                    .all_by_user(@user.id)
                    .includes(:messages)

    all_group   = @user.group_conversations.includes(:messages)

    (all_private + all_group)
      .sort_by { |c| c.messages.maximum(:created_at) || Time.at(0) }
      .reverse
  end
end
