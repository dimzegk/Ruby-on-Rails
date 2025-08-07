require "rails_helper"

RSpec.describe Shared::MessagesHelper, type: :helper do
  describe "#autoload_messenger_messages" do
    context "when in messenger and previous messages exist" do
      before do
        assign(:is_messenger, "true")
        assign(:messages_to_display_offset, 5)
      end

      it "returns load_previous_messages partial path" do
        expect(helper.autoload_messenger_messages).to eq("shared/load_more_messages/messenger/load_previous_messages")
      end
    end

    context "when in messenger and no previous messages exist" do
      before do
        assign(:is_messenger, "true")
        assign(:messages_to_display_offset, 0)
      end

      it "returns remove_previous_messages_link partial path" do
        expect(helper.autoload_messenger_messages).to eq("shared/load_more_messages/messenger/remove_previous_messages_link")
      end
    end

    context "when not in messenger" do
      before do
        assign(:is_messenger, "false")
        assign(:messages_to_display_offset, 10)
      end

      it "returns shared/empty_partial" do
        expect(helper.autoload_messenger_messages).to eq("shared/empty_partial")
      end
    end
  end
end
