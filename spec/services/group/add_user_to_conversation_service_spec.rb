require 'rails_helper'

RSpec.describe Group::AddUserToConversationService, type: :service do
  describe '#call' do
    let(:user) { create(:user) }
    let(:new_user) { create(:user) }
    let(:conversation) { create(:group_conversation, users: [ user ]) }

    subject(:service_call) do
      described_class.new({
        group_conversation_id: conversation.id,
        new_user_id: new_user.id,
        added_by_id: user.id
      }).call
    end

    it 'adds the user to the group conversation' do
      service_call
      conversation_users = Group::Conversation.find(conversation.id).users
      expect(conversation_users).to include new_user
    end

    it 'creates an informational message' do
      service_call
      group_conversation = Group::Conversation.find(conversation.id)
      expect(group_conversation.messages.count).to eq 1
    end
  end
end
