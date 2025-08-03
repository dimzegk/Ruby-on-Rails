import consumer from "../consumer";

// Συνδρομή σε όλες τις group conversations του χρήστη
if (window.gon && gon.group_conversations) {
  gon.group_conversations.forEach((convId) => {
    subToGroupConversationChannel(convId);
  });
}

function subToGroupConversationChannel(id) {
  consumer.subscriptions.create(
    { channel: "Group::ConversationChannel", id: id },
    {
      connected() {
        console.log(`✅ Connected to Group Conversation ${id}`);
      },

      disconnected() {
        console.log(`❌ Disconnected from Group Conversation ${id}`);
      },

      received(data) {
        console.log("📨 New group message received", data);

        // Μετακίνηση της συνομιλίας στην κορυφή του μενού
        modifyConversationsMenuList(data.conversation_id);

        // Εύρεση DOM element της συνομιλίας
        let conversation = findConv(data.conversation_id, "g");
        let conversation_rendered = ConvRendered(data.conversation_id, "g");
        let messages_visible = ConvMessagesVisiblity(conversation);

        // Αν το μήνυμα ΔΕΝ είναι από τον τρέχοντα χρήστη → μαρκάρουμε unseen
        MarkGroupConvAsUnseen(data.user_id, data.conversation_id);

        // Προσθήκη νέου μηνύματος
        appendGroupMessage(
          conversation_rendered,
          messages_visible,
          conversation,
          data.message
        );

        // Scroll στο τέλος αν η συνομιλία είναι ανοιχτή
        if (conversation_rendered) {
          let messages_list = conversation.find(".messages-list");
          let height = messages_list[0].scrollHeight;
          messages_list.scrollTop(height);
        }
      },

      send_message(message) {
        return this.perform("send_message", { message: message });
      },

      set_as_seen(conv_id) {
        return this.perform("set_as_seen", { conv_id: conv_id });
      },
    }
  );
}

// 📌 Event για αποστολή μηνύματος
$(document).on("submit", ".send-group-message", function (e) {
  e.preventDefault();
  let id = $(this).find("input[name=conversation_id]").val();
  let message_values = $(this).serializeArray();
  consumer.subscriptions.subscriptions
    .find((sub) => sub.identifier.includes(`"id":${id}`))
    ?.send_message(message_values);
});

// 📌 Μαρκάρισμα μηνύματος ως seen
$(document).on(
  "click",
  ".conversation-window, .group-conversation",
  function () {
    let latest_message = $(".messages-list ul li:last .row", this);
    let unseen_by_user = latest_message.hasClass("unseen");

    if (unseen_by_user) {
      let conv_id = $(this).find(".panel").data("gconversation-id");
      if (!conv_id) {
        conv_id = $(this).find(".messages-list").data("gconversation-id");
      }
      $("#menu-gc" + conv_id).removeClass("unseen-conv");
      latest_message.removeClass("unseen");
      calculateUnseenConversations();

      consumer.subscriptions.subscriptions
        .find((sub) => sub.identifier.includes(`"id":${conv_id}`))
        ?.set_as_seen(conv_id);
    }
  }
);

// 📌 Μαρκάρισμα ως unseen
function MarkGroupConvAsUnseen(message_user_id, conversation_id) {
  if (message_user_id != gon.user_id) {
    newGroupConvMenuListLink(conversation_id);
    $("#menu-gc" + conversation_id).addClass("unseen-conv");
    calculateUnseenConversations();
  }
}

// 📌 Μεταφορά συνομιλίας στην κορυφή του μενού
function modifyConversationsMenuList(conversation_id) {
  let conversation_menu_link = $("#conversations-menu ul").find(
    "#menu-gc" + conversation_id
  );
  if (conversation_menu_link.length) {
    conversation_menu_link.prependTo("#conversations-menu ul");
  }
}

// 📌 Προσθήκη μηνύματος
function appendGroupMessage(
  conversation_rendered,
  messages_visible,
  group_conversation,
  message
) {
  if (conversation_rendered) {
    if (!messages_visible) {
      // Μπορούμε να αλλάξουμε το header χρώμα
    }
    group_conversation.find(".messages-list ul").append(message);
  }
}

// 📌 Δημιουργία link αν δεν υπάρχει ήδη
function newGroupConvMenuListLink(conversation_id) {
  let id_attr = "#menu-gc" + conversation_id;
  let conversation_menu_link = $("#conversations-menu ul").find(id_attr);
  if (conversation_menu_link.length == 0) {
    let list_item = `<li id="menu-gc${conversation_id}" class="conversation-window">
                        <a data-remote="true"
                           rel="nofollow"
                           data-method="post"
                           href="/group_conversations?group_conversation_id=${conversation_id}">
                            group conversation
                        </a>
                     </li>`;
    $("#conversations-menu ul").prepend(list_item);
  }
}
