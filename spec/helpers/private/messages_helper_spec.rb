# spec/helpers/private/messages_helper_spec.rb
require 'rails_helper'

RSpec.describe Private::MessagesHelper, type: :helper do
  let(:user) { create(:user) }
  let(:conversation) { create(:private_conversation, sender: user, recipient: create(:user)) }

  describe '#private_message_date_check' do
    let(:message) { create(:private_message, conversation: conversation, sender: user) }
    let(:previous_message) { create(:private_message, conversation: conversation, sender: user) }

    it 'returns new_date partial when messages are from different days' do
      previous_message.update(created_at: 2.days.ago)
      expect(helper.private_message_date_check(message, previous_message)).to eq 'private/messages/message/new_date'
    end

    it 'returns empty partial when messages are from same day' do
      previous_message.update(created_at: Time.current)
      message.update(created_at: Time.current)
      expect(helper.private_message_date_check(message, previous_message)).to eq 'shared/empty_partial'
    end

    it 'returns empty partial when previous_message is nil' do
      expect(helper.private_message_date_check(message, nil)).to eq 'shared/empty_partial'
    end
  end

  describe '#sent_or_received' do
    let(:message) { create(:private_message, sender: user) }

    it 'returns message-sent if sender is current user' do
      expect(helper.sent_or_received(message, user)).to eq 'message-sent'
    end

    it 'returns message-received if sender is someone else' do
      other_user = create(:user)
      expect(helper.sent_or_received(message, other_user)).to eq 'message-received'
    end
  end

  describe '#seen_or_unseen' do
    let(:message) { create(:private_message, seen: false) }

    it 'returns unseen if message is not seen' do
      expect(helper.seen_or_unseen(message)).to eq 'unseen'
    end

    it 'returns empty string if message is seen' do
      message.update(seen: true)
      expect(helper.seen_or_unseen(message)).to eq ''
    end
  end
end
