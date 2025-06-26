require "rails_helper"

RSpec.feature "Contact user", type: :feature do
  let(:user) { create(:user) }
  let(:category) { create(:category, name: 'Arts', branch: 'hobby') }
  let(:post) { create(:post, category_id: category.id) }

  context 'logged in user' do
    before(:each) do
      visit new_user_session_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: '123456'
      click_button 'Log in'
    end

    scenario "successfully sends a message to a post's author", js: true do
      visit post_path(post)

      # Έλεγξε ότι η φόρμα είναι ορατή αρχικά
      expect(page).to have_selector('.contact-user form')

      # Γράψε μήνυμα και στείλε
      fill_in('message_body', with: 'a' * 20)
      find('form .send-message-to-user').click

      # Περίμενε να φύγει η φόρμα
      expect(page).not_to have_selector('.contact-user form', wait: 5)

      # Επιβεβαίωσε το μήνυμα "You are already in touch with this user"
      expect(page).to have_selector('.contacted-user', text: 'You are already in touch with this user')
    end

    scenario 'sees an already contacted message' do
      create(:private_conversation_with_messages,
             recipient_id: post.user.id,
             sender_id: user.id)

      visit post_path(post)

      expect(page).to have_selector('.contact-user .contacted-user',
                                    text: 'You are already in touch with this user')
    end
  end

  context 'non-logged in user' do
    scenario 'sees a login required message to contact a user' do
      visit post_path(post)

      expect(page).to have_selector('#contact_user', text: 'To contact the user you have to')
    end
  end
end
