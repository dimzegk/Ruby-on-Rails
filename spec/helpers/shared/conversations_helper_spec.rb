require 'rails_helper'

RSpec.describe Shared::ConversationsHelper, type: :helper do
  describe '#group_conv_seen_status' do
    it 'returns unseen-conv status when message is from another user and not seen' do
      current_user = create(:user)
      conversation = create(:group_conversation)
      create(:group_message, conversation: conversation, seen_by: [], user: create(:user))

      result = helper.group_conv_seen_status(conversation, current_user)
      expect(result).to eq('unseen-conv')
    end

    it 'returns empty string when message is from current user' do
      user = create(:user)
      conversation = create(:group_conversation)
      create(:group_message, conversation: conversation, user: user)

      result = helper.group_conv_seen_status(conversation, user)
      expect(result).to eq('')
    end

    it 'returns empty string when message is seen by user' do
      user = create(:user)
      conversation = create(:group_conversation)
      message = create(:group_message, conversation: conversation, user: create(:user))
      message.update(seen_by: [ user.id ])

      result = helper.group_conv_seen_status(conversation, user)
      expect(result).to eq('')
    end
  end
end
