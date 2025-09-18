require "rails_helper"

RSpec.feature "window", type: :feature do
  let(:user) { create(:user, password: "123456") }
  let(:conversation) { create(:private_conversation, sender: user, recipient: create(:user)) }

  before(:each) do
    conversation
    create(:private_message, conversation: conversation, sender: user)
  end

 def login_user(user)
  visit new_user_session_path

  fill_in "Email", with: user.email
  fill_in "Password", with: "123456"

  page.execute_script("document.querySelector('input[type=submit]').removeAttribute('disabled')")
  click_button "Log in"
end


def open_window
  login_user(user) # <-- εδώ δίνουμε το user
  visit root_path

  expect(page).to have_selector('#conversations-menu .dropdown-toggle', wait: 5)
  find('#conversations-menu .dropdown-toggle', wait: 5).click
  find('#conversations-menu li a', wait: 5).click
  expect(
  page.evaluate_script("getComputedStyle(document.querySelector('.conversation-window .messages-list')).display")
).to eq("none")
end


  scenario "user opens a conversation", js: true do
    open_window
  end

  scenario "user closes a conversation", js: true do
    open_window
    find('.conversation-window .close-conversation', wait: 5).click
    expect(page).not_to have_selector('.conversation-window', wait: 5)
  end

  scenario "user sends a message", js: true do
    open_window
    expect(page).to have_selector('.conversation-window .messages-list li', count: 1, wait: 5)

  within('.conversation-window') do
  fill_in 'body', with: 'hey, mate'
  find('form .send-message', wait: 5, visible: :all).click
end


    expect(page).to have_selector('.conversation-window .messages-list li', count: 2, wait: 5)
  end

  scenario "user collapses and expands a conversation window", js: true do
    open_window
    find('.conversation-window .conversation-heading', wait: 5).click
    expect(page).not_to have_selector('.conversation-window .messages-list', wait: 5)
  end
end
