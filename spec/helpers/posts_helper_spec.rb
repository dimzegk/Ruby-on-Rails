require 'rails_helper'

RSpec.describe PostsHelper, type: :helper do
  describe '#create_new_post_partial_path' do
    it "returns the signed_in partial's path" do
      allow(helper).to receive(:user_signed_in?).and_return(true)
      expect(helper.create_new_post_partial_path).to eq('posts/branch/create_new_post/signed_in')
    end

    it "returns the not_signed_in partial's path" do
      allow(helper).to receive(:user_signed_in?).and_return(false)
      expect(helper.create_new_post_partial_path).to eq('posts/branch/create_new_post/not_signed_in')
    end
  end

  describe '#all_categories_button_partial_path' do
    it "returns the all_selected partial's path when no category param" do
      controller.params[:category] = ''
      expect(helper.all_categories_button_partial_path).to eq('posts/branch/categories/all_selected')
    end

    it "returns the all_not_selected partial's path when category is present" do
      controller.params[:category] = 'some-category'
      expect(helper.all_categories_button_partial_path).to eq('posts/branch/categories/all_not_selected')
    end
  end

  describe '#no_posts_partial_path' do
    it "returns the no_posts partial's path when posts are empty" do
      assign(:posts, [])
      expect(helper.no_posts_partial_path).to eq('posts/branch/no_posts')
    end

    it "returns the empty_partial path when posts exist" do
      assign(:posts, [ 1 ])
      expect(helper.no_posts_partial_path).to eq('shared/empty_partial')
    end
  end

  describe '#post_format_partial_path' do
    it "returns home_page partial's path when on home page" do
      allow(helper).to receive(:current_page?).and_return(true)
      expect(helper.post_format_partial_path).to eq('posts/post/home_page')
    end

    it "returns branch_page partial's path when not on home page" do
      allow(helper).to receive(:current_page?).and_return(false)
      expect(helper.post_format_partial_path).to eq('posts/post/branch_page')
    end
  end

  describe '#update_pagination_partial_path' do
    it "returns update_pagination when next_page exists" do
      posts = double('posts', next_page: 2)
      assign(:posts, posts)
      expect(helper.update_pagination_partial_path).to eq('posts/posts_pagination_page/update_pagination')
    end

    it "returns remove_pagination when next_page is nil" do
      posts = double('posts', next_page: nil)
      assign(:posts, posts)
      expect(helper.update_pagination_partial_path).to eq('posts/posts_pagination_page/remove_pagination')
    end
  end

  describe '#contact_user_partial_path' do
    let(:current_user) { create(:user) }
    let(:other_user) { create(:user) }

    before do
      allow(helper).to receive(:current_user).and_return(current_user)
    end

    it "returns message form when signed in and post belongs to another user" do
      assign(:post, create(:post, user_id: other_user.id))
      allow(helper).to receive(:user_signed_in?).and_return(true)
      expect(helper.contact_user_partial_path).to eq('posts/show/contact_user')
    end

    it "returns empty partial when signed in and user is post owner" do
      assign(:post, create(:post, user_id: current_user.id))
      allow(helper).to receive(:user_signed_in?).and_return(true)
      expect(helper.contact_user_partial_path).to eq('shared/empty_partial')
    end

    it "returns login_required when not signed in" do
      allow(helper).to receive(:user_signed_in?).and_return(false)
      expect(helper.contact_user_partial_path).to eq('posts/show/login_required')
    end
  end

  describe '#leave_message_partial_path' do
    it "returns already_in_touch when message has been sent" do
      assign(:message_has_been_sent, true)
      expect(helper.leave_message_partial_path).to eq('posts/show/contact_user/already_in_touch')
    end

    it "returns message_form when message has not been sent" do
      assign(:message_has_been_sent, false)
      expect(helper.leave_message_partial_path).to eq('posts/show/contact_user/message_form')
    end
  end
end
