# spec/services/conversation_for_messenger_service_spec.rb
require "rails_helper"

RSpec.describe ConversationForMessengerService do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }

  let(:group_conversation) { create(:group_conversation) }

  let!(:private_conversation) do
    # Δημιούργησέ το πριν τα παρακάτω expectations
    create(:private_conversation,
      sender_id: user1.id,
      recipient_id: user2.id
    )
  end

  describe "#call" do
    it "returns a group conversation" do
      result = described_class.new(
        conversation_type: "group",
        group_conversation_id: group_conversation.id
      ).call

      expect(result).to eq(group_conversation)
    end

    it "returns a private conversation" do
      result = described_class.new(
        conversation_type: "private",
        user1_id: user1.id,
        user2_id: user2.id
      ).call

      expect(result).to eq(private_conversation)
    end
  end
end
