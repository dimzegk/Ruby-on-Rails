require 'rails_helper'

RSpec.describe 'Contact user', type: :feature do
  let!(:post_author) { create(:user, name: 'test_author') }
  let!(:post) { create(:post, user: post_author, title: 'Sample Title', content: 'This is a valid content with more than 20 characters.') }

  context 'logged in user' do
    let!(:user) { create(:user, name: 'test_sender') }

    before do
      login_as(user, scope: :user)
    end

    scenario 'successfully sends a message to a post\'s author' do
      Private::Conversation.delete_all

      visit post_path(post)

      expect(page).to have_selector('.contact-user form')
      fill_in 'message_body', with: 'Hello there!'
      click_button 'Send a message'

      expect(page).to have_selector('.contacted-user', text: 'Message has been sent')
    end

    scenario 'sees an already contacted message' do
      conversation = Private::Conversation.create!(
        sender_id: user.id,
        recipient_id: post_author.id,
        post_id: post.id
      )
      Private::Message.create!(
        user: user,
        conversation: conversation,
        body: 'Initial message'
      )

      visit post_path(post)

      expect(page).to have_selector('.contacted-user', text: 'You are already in touch with this user')
    end
  end

  context 'non-logged in user' do
    scenario 'sees a login required message to contact a user' do
      visit post_path(post)

      expect(page).to have_selector('#contact_user', text: 'To contact the user you have to log in or sign up first.')
    end
  end
end
