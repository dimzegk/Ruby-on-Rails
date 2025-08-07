document.addEventListener("turbo:load", () => {
  const $messagesList = $('.conversation .messages-list');
  const messagesVisible = $messagesList.find('ul li').length > 0;
  const previousMessagesExist = $messagesList.find('.load-more-messages').length > 0;

  if (!messagesVisible && previousMessagesExist) {
    $messagesList.find('.load-more-messages')[0].click();
    $messagesList.find('.loading-more-messages').hide();
  }
});
