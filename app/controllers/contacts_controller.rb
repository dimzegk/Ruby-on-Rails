class ContactsController < ApplicationController
  before_action :authenticate_user!

  def create
    @receiver = User.find(params[:contact_id])
    @contact  = current_user.contacts_sent.find_or_initialize_by(contact_id: @receiver.id)
    @contact.accepted = false if @contact.has_attribute?(:accepted)

    if @contact.save
      Turbo::StreamsChannel.broadcast_prepend_to(
        "u#{@receiver.id}:nav",
        target: "contact-requests-list",
        html: render_to_string(
          inline: %(
            <li id="<%= dom_id(@contact, :request_row) %>"
                class="px-3 py-2 d-flex align-items-center justify-content-between">
              <span>
                <i class="fa-regular fa-user me-1"></i>
                <%= h current_user.name %> sent you a request
              </span>
              <span class="d-inline-flex gap-2">
                <form class="button_to" method="post" action="<%= contact_path(id: current_user.id) %>">
                  <button class="btn btn-sm btn-outline-success" type="submit">Accept</button>
                  <input type="hidden" name="_method" value="put" />
                  <input type="hidden" name="authenticity_token" value="<%= form_authenticity_token %>" />
                  <input type="hidden" name="target" value="<%= dom_id(@contact, :request_row) %>" />
                </form>
                <form class="button_to" method="post" action="<%= contact_path(id: current_user.id) %>">
                  <button class="btn btn-sm btn-outline-danger" type="submit">Decline</button>
                  <input type="hidden" name="_method" value="delete" />
                  <input type="hidden" name="authenticity_token" value="<%= form_authenticity_token %>" />
                  <input type="hidden" name="target" value="<%= dom_id(@contact, :request_row) %>" />
                </form>
              </span>
            </li>
          )
        )
      )

      Turbo::StreamsChannel.broadcast_update_to(
        "u#{@receiver.id}:nav",
        target: "pending-requests-badge",
        html: pending_requests_badge_html(@receiver)
      )
      respond_to do |f|
        f.turbo_stream { render turbo_replace_state(@receiver) }
        f.html         { redirect_back fallback_location: root_path, notice: "Contact request sent." }
        f.json         { head :ok }
      end
    else
      respond_to do |f|
        f.turbo_stream { head :unprocessable_entity }
        f.html         { redirect_back fallback_location: root_path, alert: @contact.errors.full_messages.to_sentence }
        f.json         { render json: { errors: @contact.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end


  def update
    @other   = User.find(params[:id])
    @contact = Contact.find_by_users(@other.id, current_user.id)

    if @contact&.update(accepted: true)
      Turbo::StreamsChannel.broadcast_remove_to(
        "u#{current_user.id}:nav",
        target: (params[:target].presence || view_context.dom_id(@contact, :request_row))
      )

      Turbo::StreamsChannel.broadcast_update_to(
        "u#{current_user.id}:nav",
        target: "pending-requests-badge",
        html: pending_requests_badge_html(current_user)
      )

      respond_to do |f|
        f.turbo_stream { render turbo_replace_state(@other) }
        f.html         { redirect_back fallback_location: root_path, notice: "Contact accepted." }
        f.json         { head :ok }
      end
    else
      respond_to do |f|
        f.turbo_stream { head :unprocessable_entity }
        f.html         { redirect_back fallback_location: root_path, alert: "Could not accept contact request" }
        f.json         { head :unprocessable_entity }
      end
    end
  end

  def destroy
    @other   = User.find(params[:id])
    @contact = Contact.find_by_users(@other.id, current_user.id)

    if @contact&.destroy
      Turbo::StreamsChannel.broadcast_remove_to(
        "u#{current_user.id}:nav",
        target: (params[:target].presence || view_context.dom_id(@contact, :request_row))
      )
      Turbo::StreamsChannel.broadcast_update_to(
        "u#{current_user.id}:nav",
        target: "pending-requests-badge",
        html: pending_requests_badge_html(current_user)
      )

      respond_to do |f|
        f.turbo_stream { render turbo_replace_state(@other) }
        f.html         { redirect_back fallback_location: root_path, notice: "Request declined." }
        f.json         { head :ok }
      end
    else
      respond_to do |f|
        f.turbo_stream { head :unprocessable_entity }
        f.html         { redirect_back fallback_location: root_path, alert: "Could not decline contact request" }
        f.json         { head :unprocessable_entity }
      end
    end
  end

  private

  def pending_requests_badge_html(user)
    count =
      if Contact.column_names.include?("accepted") && Contact.column_names.include?("receiver_id")
        Contact.where(receiver_id: user.id).where(accepted: [false, nil]).count
      else
        0
      end

    cls = ["badge", "rounded-pill", "bg-danger"]
    cls << "d-none" if count.zero?

    %(<span id="pending-requests-badge" class="#{cls.join(' ')}">#{count}</span>).html_safe
  end

  def turbo_replace_state(other)
    target = params[:target].presence ||
             "pc#{params[:conversation_id]}_contact_cta" ||
             view_context.dom_id(other, :contact_cta)

    turbo_stream.replace(
      target,
      partial: "contacts/state",
      locals:  { other: other, current_user: current_user, target_id: target }
    )
  end
end
