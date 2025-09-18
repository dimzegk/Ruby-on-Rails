require 'rails_helper'

RSpec.describe Private::Message, type: :model do
  describe 'Methods' do
    it 'gets a previous message' do
      conversation = create(:private_conversation)
      message1 = create(:private_message, conversation: conversation)
      message2 = create(:private_message, conversation: conversation)

      expect(message2.previous_message).to eq(message1)
    end

    it 'returns nil when no previous message exists' do
      conversation = create(:private_conversation)
      message1 = create(:private_message, conversation: conversation)

      expect(message1.previous_message).to be_nil
    end
  end
end
