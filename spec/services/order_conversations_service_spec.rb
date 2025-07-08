require 'rails_helper'
require './app/services/order_conversations_service.rb'

RSpec.describe OrderConversationsService do
  context '#call' do
    it 'returns ordered conversations in descending order' do
      user = create(:user)

      # πρώτα message
      message1 = create(:private_message)
      conversation1 = create(:private_conversation, sender_id: user.id)
      conversation1.messages << message1

      sleep(1) # για να αλλάξει το created_at

      # δεύτερο message, πιο πρόσφατο
      message2 = create(:private_message)
      conversation2 = create(:private_conversation, sender_id: user.id)
      conversation2.messages << message2

      result = OrderConversationsService.new(user: user).call

      expect(result).to eq [ conversation2, conversation1 ]
    end
  end
end
