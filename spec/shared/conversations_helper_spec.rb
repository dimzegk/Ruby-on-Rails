# spec/helpers/private/conversations_helper_spec.rb
require 'rails_helper'

RSpec.describe Private::ConversationsHelper, type: :helper do
  let(:current_user) { create(:user) }
  let(:recipient) { create(:user) }

  before do
    allow(helper).to receive(:current_user).and_return(current_user)
    view.assigns[:recipient] = recipient
  end

  describe '#private_conv_seen_status' do
    it 'returns an empty string if last message is from current user' do
      conversation = create(:private_conversation)
      create(:private_message, conversation: conversation, seen: false, sender_id: current_user.id)

      expect(helper.private_conv_seen_status(conversation)).to eq ''
    end

    it 'returns an empty string if last message was already seen' do
      conversation = create(:private_conversation)
      create(:private_message, conversation: conversation, seen: true, sender_id: recipient.id)

      expect(helper.private_conv_seen_status(conversation)).to eq ''
    end

    it 'returns unseen-conv if message is unseen and not from current user' do
      conversation = create(:private_conversation)
      create(:private_message, conversation: conversation, seen: false, sender_id: recipient.id)

      expect(helper.private_conv_seen_status(conversation)).to eq 'unseen-conv'
    end
  end

  describe '#add_to_contacts_partial_path' do
    let(:contact) { create(:contact) }

    it 'returns empty partial when recipient is contact' do
      allow(helper).to receive(:recipient_is_contact?).and_return(true)
      expect(helper.add_to_contacts_partial_path(contact)).to eq 'shared/empty_partial'
    end

    it 'returns add_user_to_contacts partial if no contact or request' do
      allow(helper).to receive(:recipient_is_contact?).and_return(false)
      allow(helper).to receive(:unaccepted_contact_exists).and_return(false)

      expect(helper.add_to_contacts_partial_path(contact)).to eq(
        'private/conversations/conversation/heading/add_user_to_contacts'
      )
    end
  end

  describe '#conv_heading_class' do
    let(:contact) { create(:contact) }

    it 'returns conversation-heading-full if contact not accepted' do
      contact.update(accepted: false)
      expect(helper.conv_heading_class(contact)).to eq 'conversation-heading-full'
    end

    it 'returns conversation-heading if contact is accepted' do
      contact.update(accepted: true)
      expect(helper.conv_heading_class(contact)).to eq 'conversation-heading'
    end
  end

  describe '#get_contact_record' do
    it 'returns the contact where current_user is sender' do
      contact = create(:contact, user: current_user, contact: recipient)
      expect(helper.get_contact_record(recipient)).to eq(contact)
    end

    it 'returns the contact where recipient is sender' do
      contact = create(:contact, user: recipient, contact: current_user)
      expect(helper.get_contact_record(recipient)).to eq(contact)
    end

    it 'returns nil when no contact exists' do
      expect(helper.get_contact_record(recipient)).to be_nil
    end
  end

  describe '#unaccepted_contact_request_partial_path' do
    let(:contact) { create(:contact) }

    it 'returns sent_by_current_user partial' do
      allow(helper).to receive(:unaccepted_contact_exists).and_return(true)
      allow(helper).to receive(:request_sent_by_user).and_return(true)

      expect(helper.unaccepted_contact_request_partial_path(contact)).to eq(
        'private/conversations/conversation/request_status/sent_by_current_user'
      )
    end

    it 'returns sent_by_recipient partial' do
      allow(helper).to receive(:unaccepted_contact_exists).and_return(true)
      allow(helper).to receive(:request_sent_by_user).and_return(false)

      expect(helper.unaccepted_contact_request_partial_path(contact)).to eq(
        'private/conversations/conversation/request_status/sent_by_recipient'
      )
    end

    it 'returns shared/empty_partial if no unaccepted request' do
      allow(helper).to receive(:unaccepted_contact_exists).and_return(false)

      expect(helper.unaccepted_contact_request_partial_path(contact)).to eq('shared/empty_partial')
    end
  end

  describe '#not_contact_no_request_partial_path' do
    let(:contact) { create(:contact) }

    it 'returns send_request partial if no contact and no request exists' do
      allow(helper).to receive(:recipient_is_contact?).and_return(false)
      allow(helper).to receive(:unaccepted_contact_exists).and_return(false)

      expect(helper.not_contact_no_request_partial_path(contact)).to eq(
        'private/conversations/conversation/request_status/send_request'
      )
    end

    it 'returns empty partial if recipient is contact' do
      allow(helper).to receive(:recipient_is_contact?).and_return(true)
      allow(helper).to receive(:unaccepted_contact_exists).and_return(false)

      expect(helper.not_contact_no_request_partial_path(contact)).to eq('shared/empty_partial')
    end

    it 'returns empty partial if unaccepted contact request exists' do
      allow(helper).to receive(:recipient_is_contact?).and_return(false)
      allow(helper).to receive(:unaccepted_contact_exists).and_return(true)

      expect(helper.not_contact_no_request_partial_path(contact)).to eq('shared/empty_partial')
    end
  end

  describe '#request_sent_by_user' do
    it 'returns true if current_user sent the request' do
      contact = create(:contact, user: current_user)
      expect(helper.send(:request_sent_by_user, contact)).to be true
    end

    it 'returns false if recipient sent the request' do
      contact = create(:contact, user: recipient)
      expect(helper.send(:request_sent_by_user, contact)).to be false
    end
  end

  describe '#unaccepted_contact_exists' do
    it 'returns true if contact is present and not accepted' do
      contact = create(:contact, accepted: false)
      expect(helper.send(:unaccepted_contact_exists, contact)).to eq true
    end

    it 'returns false if contact is accepted' do
      contact = create(:contact, accepted: true)
      expect(helper.send(:unaccepted_contact_exists, contact)).to eq false
    end

    it 'returns false if contact is nil' do
      expect(helper.send(:unaccepted_contact_exists, nil)).to eq false
    end
  end
end

# -----------------------------------------------
# spec/helpers/group/conversations_helper_spec.rb
# -----------------------------------------------
require 'rails_helper'

RSpec.describe Group::ConversationsHelper, type: :helper do
  context '#load_group_messages_partial_path' do
    let(:conversation) { create(:group_conversation) }

    it "returns load_messages partial's path" do
      create_list(:group_message, 2, conversation_id: conversation.id)
      expect(helper.load_group_messages_partial_path(conversation)).to eq(
        'group/conversations/conversation/messages_list/load_messages'
      )
    end

    it "returns an empty partial's path" do
      expect(helper.load_group_messages_partial_path(conversation)).to eq(
        'shared/empty_partial'
      )
    end
  end
end
