require 'rails_helper'

RSpec.describe Private::ConversationsHelper, type: :helper do
  context '#load_private_messages' do
    let(:conversation) { create(:private_conversation) }

    it "returns load_messages partial's path" do
      create(:private_message, conversation_id: conversation.id)
      expect(helper.load_private_messages(conversation)).to eq(
        'private/conversations/conversation/messages_list/link_to_previous_messages'
      )
    end

    it "returns empty partial's path" do
      expect(helper.load_private_messages(conversation)).to eq(
        'shared/empty_partial'
      )
    end
  end

  describe '#create_group_conv_partial_path' do
    let(:contact) { create(:user) }

    it "returns the create_group_conversation partial's path" do
      allow(helper).to receive(:recipient_is_contact?).with(contact).and_return(true)
      expect(helper.create_group_conv_partial_path(contact)).to eq(
        'private/conversations/conversation/heading/create_group_conversation'
      )
    end

    it "returns the shared/empty_partial path" do
      allow(helper).to receive(:recipient_is_contact?).with(contact).and_return(false)
      expect(helper.create_group_conv_partial_path(contact)).to eq(
        'shared/empty_partial'
      )
    end
  end
end
