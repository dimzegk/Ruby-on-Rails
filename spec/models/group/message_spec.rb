require 'rails_helper'

RSpec.describe Group::Message, type: :model do
  let(:message) { build(:group_message) }

  context 'Associations' do
    it 'belongs_to group_conversation' do
      assoc = described_class.reflect_on_association(:conversation)
      expect(assoc.macro).to eq :belongs_to
      expect(assoc.options[:class_name]).to eq 'Group::Conversation'
      expect(assoc.options[:foreign_key]).to eq 'conversation_id'
    end
  end

  context 'Validations' do
    it "is not valid without content" do
      message.content = nil
      expect(message).not_to be_valid
    end

    it "is not valid without conversation_id" do
      message.conversation_id = nil
      expect(message).not_to be_valid
    end

    it "is not valid without user_id" do
      message.user_id = nil
      expect(message).not_to be_valid
    end
  end

  context 'Methods' do
    it 'gets previous message of conversation' do
      conversation = create(:group_conversation)
      m1 = create(:group_message, conversation: conversation)
      m2 = create(:group_message, conversation: conversation)
      expect(m2.previous_message).to eq m1
    end
  end
end
