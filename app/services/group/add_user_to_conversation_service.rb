class Group::AddUserToConversationService
  def initialize(params)
    @group_conversation_id = params[:group_conversation_id]
    @new_user_id = params[:new_user_id]
    @added_by_id = params[:added_by_id]
  end

  def call
    group_conversation = Group::Conversation.find(@group_conversation_id)
    new_user = User.find(@new_user_id)
    added_by = User.find(@added_by_id)

    # Μην τον ξαναπροσθέτεις αν είναι ήδη μέλος
    unless group_conversation.users.include?(new_user)
      group_conversation.users << new_user
      create_info_message(new_user, added_by)
    end
  end

  private

  def create_info_message(new_user, added_by)
    message = Group::Message.new(
      user_id: added_by.id,
      body: "#{new_user.name} added by #{added_by.name}", # Αν το column λέγεται body
      added_new_users: [ new_user.id ],
      group_conversation_id: @group_conversation_id
    )

    if message.save
      Group::MessageBroadcastJob.perform_later(message, nil, nil)
    end
  end
end
