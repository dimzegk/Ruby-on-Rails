module PostsHelper
  def create_new_post_partial_path
    user_signed_in? ? "posts/branch/create_new_post/signed_in" : "posts/branch/create_new_post/not_signed_in"
  end

  def all_categories_button_partial_path
    params[:category].blank? ? "posts/branch/categories/all_selected" : "posts/branch/categories/all_not_selected"
  end

  def no_posts_partial_path(posts)
    posts.empty? ? "posts/shared/no_posts" : "shared/empty_partial"
  end

  def post_format_partial_path
    current_page?(root_path) ? "posts/post/home_page" : "posts/post/branch_page"
  end

  def category_field_partial_path
    params[:category].present? ? "posts/branch/search_form/category_field" : "shared/empty_partial"
  end

  def update_pagination_partial_path
    @posts.next_page ? "posts/posts_pagination_page/update_pagination" : "posts/posts_pagination_page/remove_pagination"
  end
def contact_user_partial_path(post = nil)
    post ||= @post

    return "posts/show/contact_user/login_required" unless user_signed_in?
    return "posts/show/contact_user/own_post" if post && post.user_id == current_user.id

    if defined?(@message_has_been_sent) && @message_has_been_sent
      return "posts/show/contact_user/message_form/message_sent"
    end

    if post && current_user.already_in_contact?(post.user)
      "posts/show/contact_user/already_in_touch"
    else
      "posts/show/contact_user/message_form/form"
    end
  end

  def leave_message_partial_path
    if defined?(@message_has_been_sent) && @message_has_been_sent
      "posts/show/contact_user/message_form/message_sent"
    else
      "posts/show/contact_user/message_form/form"
    end
  end
end
