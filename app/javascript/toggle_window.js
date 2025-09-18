import $ from "jquery";
document.addEventListener('turbo:load', () => {
  $('#conversations-menu').on('click', 'li', function (e) {

    var conv_id = $(this).attr('data-id');

    var conv_type = $(this).attr('data-type') === 'private' ? '#pc' : '#gc';

    var conversation_window = $(conv_type + conv_id);


    if (conversation_window.length) {
      if (conversation_window.find('.panel-body').css('display') === 'none') {
        conversation_window.find('.conversation-heading').click();
      }


      conversation_window.find('form textarea').click().focus();
    }
  });


  $('.conversation-heading, .conversation-heading-full').on('click', function () {
    var panel = $(this).closest('.conversation-window');
    var panel_body = panel.find('.panel-body');
    var conversation_heading = panel.find('.conversation-heading, .conversation-heading-full');

    panel_body.slideToggle(100);

    if (panel_body.css('display') === 'none') {
      panel.find('.add-people-to-chat,\
                  .add-user-to-contacts,\
                  .contact-request-sent').hide();
      conversation_heading.css('width', '360px');
    } else {
      panel.find('.add-people-to-chat,\
                  .add-user-to-contacts,\
                  .contact-request-sent').show();
      conversation_heading.css('width', '320px');
      panel.find('form textarea').focus();
    }
  });
});
