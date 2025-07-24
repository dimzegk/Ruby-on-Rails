require 'rails_helper'

RSpec.describe Group::ConversationsHelper, type: :helper do
  describe '#add_people_to_group_conv_list' do
    let(:conversation) { create(:group_conversation) }
    let(:current_user) { create(:user) }
    let(:user) { create(:user) }

    before do
      # accepted contact (διπλή εγγραφή)
      create(:contact, user: current_user, contact: user, accepted: true)
      create(:contact, user: user, contact: current_user, accepted: true)
    end

    it 'does NOT include a user who is already in the conversation' do
      conversation.users << current_user
      conversation.users << user
      allow(helper).to receive(:current_user).and_return(current_user)

      expect(helper.add_people_to_group_conv_list(conversation)).not_to include(user)
    end

    it 'includes a user who is NOT in the conversation' do
      conversation.users << current_user
      allow(helper).to receive(:current_user).and_return(current_user)

      expect(helper.add_people_to_group_conv_list(conversation)).to include(user)
    end
  end
end
