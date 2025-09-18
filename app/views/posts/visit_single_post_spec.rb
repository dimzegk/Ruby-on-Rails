require "rails_helper"

RSpec.feature "Visit single post", type: :feature, js: true do
  let!(:user) { create(:user) }
  let!(:post) { create(:post, user: user) }

  scenario "User opens post modal and visits full post page" do
    visit root_path
    expect(page).to have_selector(".single-post-card")
    page.find(".single-post-card").click
    expect(page).to have_selector(".modal.show")
    within(".modal") do
      click_link "I'm interested"
    end
    expect(page).to have_selector("#single-post-content")
    expect(page).to have_content(post.title)
    expect(page).to have_content(post.content)
  end
end
