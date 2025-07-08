import consumer from "../../consumer";
import { findConv, ConvRendered, ConvMessagesVisiblity } from "../shared/conversation";


const conversationChannel = consumer.subscriptions.create("Private::ConversationChannel", {
  connected() {
    console.log("✅ Connected to Private::ConversationChannel");
  },

  disconnected() {
    console.log("❌ Disconnected from Private::ConversationChannel");
  },

  received(data) {
  console.log("📩 Received:", data);

  // Μετακίνηση link στην κορυφή του μενού, αν υπάρχει
  const menuLink = document.querySelector(`#menu-pc${data.conversation_id}`);
  const menuList = document.querySelector("#conversations-menu ul");
  if (menuLink && menuList) {
    menuList.insertBefore(menuLink, menuList.firstChild);
  }

  const conversation = findConv(data.conversation_id, 'p');
  const conversationRendered = ConvRendered(data.conversation_id, 'p');
  const messagesVisible = ConvMessagesVisiblity(conversation);

  if (data.recipient === true) {
    const menuLink = document.querySelector(`#menu-pc${data.conversation_id}`);
    if (menuLink) menuLink.classList.add("unseen-conv");

    if (conversationRendered) {
      if (!messagesVisible) {
        // optional: πρόσθεσε class π.χ. για highlight unseen
      }
      const ul = conversation.querySelector(".messages-list ul");
      if (ul) ul.insertAdjacentHTML("beforeend", data.message);
    }

    calculateUnseenConversations();
  } else {
    const ul = conversation?.querySelector("ul");
    if (ul) ul.insertAdjacentHTML("beforeend", data.message);
  }

  if (conversation) {
    const messagesList = conversation.querySelector(".messages-list");
    if (messagesList) {
      messagesList.scrollTop = messagesList.scrollHeight;
    }
  }
},

  send_message(message) {
    return this.perform('send_message', {
      message: message
    });
  }
});

// Expose globally so other scripts can use it
window.conversationChannel = conversationChannel;
