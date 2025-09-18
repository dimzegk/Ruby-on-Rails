require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do
  describe "#private_conversations_windows" do
    let(:conversations) { create_list(:private_conversation, 2) }

    it "returns private conversations when not on messenger page" do
      assign(:private_conversations_windows, conversations)
      allow(controller).to receive(:controller_path).and_return("home") # οτιδήποτε εκτός messengers
      expect(helper.private_conversations_windows).to eq(conversations)
    end

    it "returns an empty array on messenger page" do
      assign(:private_conversations_windows, conversations)
      allow(controller).to receive(:controller_path).and_return("messengers")
      expect(helper.private_conversations_windows).to eq([])
    end

    it "returns [] when instance var is nil (hardening)" do
      assign(:private_conversations_windows, nil)
      allow(controller).to receive(:controller_path).and_return("home")
      expect(helper.private_conversations_windows).to eq([])
    end
  end

  describe "#group_conversations_windows" do
    let(:conversations) { create_list(:group_conversation, 2) }

    it "returns group conversations when not on messenger page" do
      assign(:group_conversations_windows, conversations)
      allow(controller).to receive(:controller_path).and_return("home")
      expect(helper.group_conversations_windows).to eq(conversations)
    end

    it "returns an empty array on messenger page" do
      assign(:group_conversations_windows, conversations)
      allow(controller).to receive(:controller_path).and_return("messengers")
      expect(helper.group_conversations_windows).to eq([])
    end

    it "returns [] when instance var is nil (hardening)" do
      assign(:group_conversations_windows, nil)
      allow(controller).to receive(:controller_path).and_return("home")
      expect(helper.group_conversations_windows).to eq([])
    end
  end
end
