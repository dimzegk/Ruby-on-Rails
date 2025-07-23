require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the Group::ConversationsHelper. For example:
#
# describe Group::ConversationsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe Group::ConversationsHelper, type: :helper do
  pending "add some examples to (or delete) #{__FILE__}"
end
# spec/helpers/application_helper_spec.rb
require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#contacts_except_recipient' do
    it 'returns all contacts, except the opposite user of the chat' do
      current_user = create(:user)
      recipient = create(:user)
      other_contacts = create_list(:user, 3)

      # accepted contacts
      other_contacts.each do |contact|
        create(:contact, user: current_user, contact: contact, accepted: true)
        create(:contact, user: contact, contact: current_user, accepted: true)
      end

      # also create a contact with recipient
      create(:contact, user: current_user, contact: recipient, accepted: true)
      create(:contact, user: recipient, contact: current_user, accepted: true)

      allow(helper).to receive(:current_user).and_return(current_user)

      result = helper.contacts_except_recipient(recipient)

      expect(result).not_to include recipient
      expect(result.map(&:id)).to match_array(other_contacts.map(&:id))
    end
  end
end
