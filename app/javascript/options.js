document.addEventListener('turbo:load', function () {

  document.body.addEventListener('click', function (e) {
    const target = e.target.closest('.add-people-to-chat');
    if (!target) return;

    const selectBox = target.nextElementSibling;
    if (selectBox) {
      if (selectBox.style.display === 'none' || !selectBox.style.display) {
        selectBox.style.display = 'block';
      } else {
        selectBox.style.display = 'none';
      }
    }
  });


  document.body.addEventListener('click', function (e) {
    const target = e.target.closest('.add-user-to-contacts, .add-user-to-contacts-notif');
    if (!target) return;

    const conversationWindow = target.closest('.conversation-window, .conversation');
    if (!conversationWindow) return;

    const contactRequestSentHTML = `
      <div class="contact-request-sent" style="display: block;">
        <div>
          <i class="fa fa-question" aria-hidden="true" title="Contact request sent"></i>
        </div>
      </div>
    `;
    const addToContacts = conversationWindow.querySelector('.add-user-to-contacts');
    if (addToContacts) addToContacts.outerHTML = contactRequestSentHTML;

    const message = conversationWindow.querySelector('.add-user-to-contacts-message');
    if (message) message.remove();

    const messagesList = conversationWindow.querySelector('.messages_list ul');
    if (messagesList) {
      const li = document.createElement('div');
      li.className = 'add-user-to-contacts-message';
      li.innerText = 'Contact request sent';
      messagesList.appendChild(li);
    }

    const senderUserName = document.querySelector('nav #user-name')?.innerText;
    const receiverUserName = conversationWindow.querySelector('.contact-name-notif')?.innerText;

    if (senderUserName && receiverUserName && window.App?.notification) {
      App.notification.contact_request_response(senderUserName, receiverUserName, 'contact-request-received');
    }
  });
});
