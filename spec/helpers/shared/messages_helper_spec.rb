require 'rails_helper'

RSpec.describe Shared::MessagesHelper, type: :helper do
  describe '#remove_link_to_messages' do
    context 'when not in messenger and no more messages left' do
      it 'returns remove_more_messages_link partial' do
        assign(:is_messenger, 'false')
        assign(:messages_to_display_offset, 0)
        expect(helper.remove_link_to_messages).to eq 'shared/load_more_messages/window/remove_more_messages_link'
      end
    end

    context 'when not in messenger and more messages exist' do
      it 'returns empty_partial' do
        assign(:is_messenger, 'false')
        assign(:messages_to_display_offset, 10)
        expect(helper.remove_link_to_messages).to eq 'shared/empty_partial'
      end
    end

    context 'when in messenger' do
      it 'returns empty_partial' do
        assign(:is_messenger, 'true')
        assign(:messages_to_display_offset, 0)
        expect(helper.remove_link_to_messages).to eq 'shared/empty_partial'
      end
    end
  end
end
