require 'rails_helper'

RSpec.describe NavigationHelper, type: :helper do
  describe '#collapsible_links_partial_path' do
    context 'when the user is signed in' do
      before(:each) do
        allow(helper).to receive(:user_signed_in?).and_return(true)
      end

      it "returns signed_in_links partial's path" do
        expect(helper.collapsible_links_partial_path).to eq('layouts/navigation/collapsible_elements/signed_in_links')
      end
    end

    context 'when the user is not signed in' do
      before(:each) do
        allow(helper).to receive(:user_signed_in?).and_return(false)
      end

      it "returns non_signed_in_links partial's path" do
        expect(helper.collapsible_links_partial_path).to eq('layouts/navigation/collapsible_elements/non_signed_in_links')
      end
    end
  end

  describe '#nav_header_content_partials' do
    it "returns messenger_header partial's path" do
      controller.params[:controller] = 'messengers'
      partials = [ 'layouts/navigation/header/messenger_header' ]
      expect(helper.nav_header_content_partials).to eq partials
    end

    it "returns partials' paths for buttons without dropdowns" do
      controller.params[:controller] = 'not_messengers'
      allow(view).to receive(:user_signed_in?).and_return(false)
      partials = [ 'layouts/navigation/header/toggle_button' ]
      partials << 'layouts/navigation/header/home_button'
      expect(helper.nav_header_content_partials).to eq partials
    end

    it "returns partials' paths for buttons and dropdowns" do
      controller.params[:controller] = 'not_messengers'
      allow(view).to receive(:user_signed_in?).and_return(true)
      partials = [ 'layouts/navigation/header/toggle_button' ]
      partials << 'layouts/navigation/header/home_button'
      partials << 'layouts/navigation/header/dropdowns'
      expect(helper.nav_header_content_partials).to eq partials
    end
  end

  describe '#conversation_header_partial_path' do
    it "returns a partial's path for a private conversation's header" do
      conversation = create(:private_conversation)
      expect(helper.conversation_header_partial_path(conversation)).to eq(
        'layouts/navigation/header/dropdowns/conversations/private_conversation'
      )
    end

    it "returns a partial's path for a group conversation's header" do
      conversation = create(:group_conversation)
      expect(helper.conversation_header_partial_path(conversation)).to eq(
        'layouts/navigation/header/dropdowns/conversations/group_conversation'
      )
    end
  end

  describe '#nav_contact_requests_partial_path' do
    let(:user) { create(:user) }

    context 'when there are pending contact requests' do
      before do
        allow(helper).to receive(:current_user).and_return(user)
        allow(user).to receive(:pending_received_contact_requests).and_return([ build_stubbed(:user) ])
      end

      it 'returns the requests partial path' do
        expect(helper.nav_contact_requests_partial_path).to eq(
          'layouts/navigation/header/dropdowns/contact_requests/requests'
        )
      end
    end

    context 'when there are no pending contact requests' do
      before do
        allow(helper).to receive(:current_user).and_return(user)
        allow(user).to receive(:pending_received_contact_requests).and_return([])
      end

      it 'returns the no_requests partial path' do
        expect(helper.nav_contact_requests_partial_path).to eq(
          'layouts/navigation/header/dropdowns/contact_requests/no_requests'
        )
      end
    end
  end
end
