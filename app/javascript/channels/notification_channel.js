import consumer from "./consumer";

const notificationChannel = consumer.subscriptions.create("NotificationChannel", {
  connected() {
    console.log("🔔 NotificationChannel connected");
  },

  disconnected() {
    console.log("🔌 NotificationChannel disconnected");
  },

  received(data) {
    if (data.notification === "accepted-contact-request") {
      console.log("✅ Contact request accepted by", data.sender_user_name);

    }

    if (data.notification === "declined-contact-request") {
      console.log("❌ Contact request declined by", data.sender_user_name);
    }


    if (data.notification === "contact-request-received") {
      const conversationWindow = document.querySelector(`[data-pconversation-user-name="${data.sender_name}"]`);
      const requestsList = document.querySelector("#contacts-requests ul");
      const noRequestsMsg = document.querySelector("#contacts-requests ul .no-requests");

      if (noRequestsMsg) noRequestsMsg.remove(); // Αφαίρεση "You have no requests"
      
      if (conversationWindow) {
        const contactBtn = conversationWindow.querySelector('.add-user-to-contacts');
        if (contactBtn) contactBtn.remove();

        const msg = conversationWindow.querySelector('.add-user-to-contacts-message');
        if (msg) msg.parentElement.remove();

        const header = conversationWindow.querySelector('.conversation-heading');
        if (header) header.style.width = '360px';
      }

      if (requestsList) {
        requestsList.insertAdjacentHTML('afterbegin', data.contact_request);
      }

      calculateContactRequests?.();
    }
  },

  contact_request_response(sender_user_name, receiver_user_name, notification) {
    return this.perform("contact_request_response", {
      sender_user_name,
      receiver_user_name,
      notification
    });
  }
});

export default notificationChannel;
