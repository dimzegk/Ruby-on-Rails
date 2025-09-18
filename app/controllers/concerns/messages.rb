
require "active_support/concern"

module Messages
  extend ActiveSupport::Concern

  def get_messages(conversation_type, messages_amount)
    model = "#{conversation_type.camelize}::Conversation".constantize
    conv_param_key = conversation_type == "group" ? :group_conversation_id : :private_conversation_id
    conv_id =
      params[:conversation_id] ||
      params[:id] ||
      params[conv_param_key] ||
      params.dig(:message, :conversation_id)

    return head :bad_request unless conv_id.present?

    @conversation = model.find_by(id: conv_id)
    return head :not_found unless @conversation

    @messages = @conversation.messages
                             .order(created_at: :desc)
                             .limit(messages_amount)
                             .offset(params[:messages_to_display_offset].to_i)
                             .reverse

    @messages_to_display_offset = params[:messages_to_display_offset].to_i + messages_amount
    @messages_to_display_offset = 0 if @conversation.messages.count < @messages_to_display_offset

    @type = conversation_type.downcase
  end
end
