import consumer from "../consumer";
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
 set_as_seen(conv_id) {
      return this.perform("set_as_seen", { conv_id: conv_id });
    }
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
// When a private conversation window is clicked
$(document).on('click', '.conversation-window, .private-conversation', function (e) {
  // Find the latest message inside this window
  const latest_message = $('.messages-list ul li:last .row div', this);

  // If it's a received message and hasn't been seen
  if (latest_message.hasClass('message-received') && latest_message.hasClass('unseen')) {
    let conv_id = $(this).find('.panel').attr('data-pconversation-id');

    if (conv_id == null) {
      conv_id = $(this).find('.messages-list').attr('data-pconversation-id');
    }

    // Mark as seen locally
    latest_message.removeClass('unseen');
    $('#menu-pc' + conv_id).removeClass('unseen-conv');

    // Recalculate unseen count
    calculateUnseenConversations();

    // Tell ActionCable to mark as seen on server
    if (window.App && App.private_conversation && App.private_conversation.set_as_seen) {
      App.private_conversation.set_as_seen(conv_id);
    }
  }
});

// Recalculate unseen count on each Turbo visit
$(document).on('turbo:load', function () {
  calculateUnseenConversations();
});
