// when the link to open a conversation is clicked
// and the conversation window already exists on the page
// but it is collapsed, expand it
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
});
