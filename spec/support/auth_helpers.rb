# spec/support/auth_helpers.rb

module AuthHelpers
  def login_through_ui(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password' # ή ό,τι έχεις στο factory
    click_button 'Log in'
  end
end
