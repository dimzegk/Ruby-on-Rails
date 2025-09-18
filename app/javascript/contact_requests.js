import $ from "jquery";
document.addEventListener("turbo:load", () => {
function calculateContactRequests() {
  const count = $('#contacts-requests ul').find('.contact-request').length;
  const $badge = $('#unresponded-contact-requests');
  if (count) {
    $badge.css('visibility', 'visible').text(count);
  } else {
    $badge.css('visibility', 'hidden').text('');
  }
}

$(document).on('turbo:load', function () {

  $(document).on('ajax:success', '.accept-request a', function () {
    const $item = $(this).closest('[data-user-name]');
    const receiver_user_name = $item.data('user-name');

    $item.find('.decline-request').remove();
    $item.find('.accept-request').replaceWith('<span class="accepted-request">Accepted</span>');
    $item.removeClass('contact-request').addClass('contact-request-responded');

    let $status = $('.conversation-window').find('[data-user-name="' + receiver_user_name + '"]');
    if ($status.length === 0) { $status = $('.contact-request-status'); }
    $status.replaceWith('<div class="contact-request-status">Request has been accepted</div>');

    calculateContactRequests();

    const sender_user_name = $('nav #user-name').text();
    if (window.App?.notification?.contact_request_response) {
      App.notification.contact_request_response(sender_user_name, receiver_user_name, 'accepted-contact-request');
    }
  });


  $(document).on('ajax:success', '.decline-request a', function () {
    const $item = $(this).closest('[data-user-name]');
    const receiver_user_name = $item.data('user-name');

    $item.find('.accept-request').remove();
    $item.find('.decline-request').replaceWith('<span class="accepted-request">Declined</span>');
    $item.removeClass('contact-request').addClass('contact-request-responded');

    let $status = $('.conversation-window').find('[data-user-name="' + receiver_user_name + '"]');
    if ($status.length === 0) { $status = $('.contact-request-status'); }
    $status.replaceWith('<div class="contact-request-status">Request has been declined</div>');

    calculateContactRequests();

    const sender_user_name = $('nav #user-name').text();
    if (window.App?.notification?.contact_request_response) {
      App.notification.contact_request_response(sender_user_name, receiver_user_name, 'declined-contact-request');
    }
  });


  $(document).on('click', '.add-user-to-contacts-notif', function () {
    const sender_user_name = $('nav #user-name').text();
    const receiver_user_name = $(this).closest('.conversation-window')
                                      .find('.contact-name-notif').text();
    if (window.App?.notification?.contact_request_response) {
      App.notification.contact_request_response(sender_user_name, receiver_user_name, 'contact-request-received');
    }
  });

  calculateContactRequests();
})
})