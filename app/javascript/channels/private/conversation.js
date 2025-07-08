import consumer from "../consumer"

consumer.subscriptions.create("Private::ConversationChannel", {
  connected() {
    console.log("✅ Connected to Private::ConversationChannel");
  },
  disconnected() {
    console.log("❌ Disconnected from Private::ConversationChannel");
  },
  received(data) {
    console.log("📩 Received:", data);
  }
});
