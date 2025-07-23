document.addEventListener('turbo:load', () => {
  $('#conversations-menu').on('click', 'li', function (e) {
    // get conversation window's id
    var conv_id = $(this).attr('data-id');
    // get conversation's type
    var conv_type = $(this).attr('data-type') === 'private' ? '#pc' : '#gc';

    var conversation_window = $(conv_type + conv_id);

    // if conversation window exists
    if (conversation_window.length) {
      // if window is collapsed, expand it
      if (conversation_window.find('.panel-body').css('display') === 'none') {
        conversation_window.find('.conversation-heading').click();
      }

      // mark as seen by clicking it and focus textarea
      conversation_window.find('form textarea').click().focus();
    }
  });

  // toggle window on heading click
  $('.conversation-heading, .conversation-heading-full').on('click', function () {
    var panel = $(this).closest('.conversation-window');
    var panel_body = panel.find('.panel-body');
    var conversation_heading = panel.find('.conversation-heading, .conversation-heading-full');

    panel_body.slideToggle(100);

    // if window is collapsed, hide conversation menu options
    if (panel_body.css('display') === 'none') {
      panel.find('.add-people-to-chat,\
                  .add-user-to-contacts,\
                  .contact-request-sent').hide();
      conversation_heading.css('width', '360px');
    } else {
      // show conversation menu options
      panel.find('.add-people-to-chat,\
                  .add-user-to-contacts,\
                  .contact-request-sent').show();
      conversation_heading.css('width', '320px');
      // focus textarea
      panel.find('form textarea').focus();
    }
  });
});
