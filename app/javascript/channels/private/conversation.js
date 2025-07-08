import consumer from "../../consumer";

const conversationChannel = consumer.subscriptions.create("Private::ConversationChannel", {
  connected() {
    console.log("✅ Connected to Private::ConversationChannel");
  },

  disconnected() {
    console.log("❌ Disconnected from Private::ConversationChannel");
  },

  received(data) {
    console.log("📩 Received:", data);
    // εδώ μπορείς να κάνεις append το νέο μήνυμα στο DOM
  },
send_message: function(message) {
  return this.perform('send_message', {
    message: message
  });
}

  send_message(data) {
    this.perform("send_message", data);
  }
});

// Expose για χρήση από άλλο αρχείο
window.conversationChannel = conversationChannel;
