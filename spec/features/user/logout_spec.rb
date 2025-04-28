require "rails_helper"

RSpec.feature "Logout", type: :feature do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }

  scenario 'user successfully logs out', js: true do
    sign_in user
    visit root_path

    page.driver.submit :delete, destroy_user_session_path, {}

    visit root_path
    expect(page).to have_selector('nav a', text: 'Login')
  end
end
