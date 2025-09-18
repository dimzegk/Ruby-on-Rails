import consumer from "../consumer"

consumer.subscriptions.create("Group::ConversationChannel", {
  connected() {
  },

  disconnected() {
  },

  received(data) {
  }
});
