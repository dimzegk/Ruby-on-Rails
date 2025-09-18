import consumer from "../consumer"
import { findConv, ConvRendered, ConvMessagesVisiblity } from "../shared/conversation"

window.App = window.App || {}
if (window.App.private_conversation && window.App.private_conversation.unsubscribe) {
  try { window.App.private_conversation.unsubscribe() } catch (e) {}
  window.App.private_conversation = null
}

const conversationChannel = consumer.subscriptions.create("Private::ConversationChannel", {
  connected() {
    console.log("✅ Connected to Private::ConversationChannel")
  },

  disconnected() {
    console.log("❌ Disconnected from Private::ConversationChannel")
  },
received(data) {
  if (!data) return;
  if (data.action && data.action !== "append_message") return;

  const convId = data.conversation_id || data.conv_id;
  const html   = data.message || data.html;
  if (!convId || !html) return;

  console.log("📩 Received:", { convId, snippet: html.slice(0, 80) });


  let insertTarget = document.querySelector(`#conversation_${convId}_messages`) || null;
  if (insertTarget && insertTarget.tagName !== "UL") {
    const maybeUl = insertTarget.querySelector("ul");
    if (maybeUl) insertTarget = maybeUl;
  }


  if (!insertTarget) {
    const conversation = findConv(convId, "p");
    if (conversation) {
      insertTarget = conversation.querySelector(".messages-list ul") ||
                     conversation.querySelector(".messages-list");
    } else {
      insertTarget = document.querySelector(`[data-pconversation-id="${convId}"] .messages-list ul`) ||
                     document.querySelector(`[data-pconversation-id="${convId}"] .messages-list`);
    }
    if (insertTarget && insertTarget.tagName !== "UL") {
      const maybeUl = insertTarget.querySelector("ul");
      if (maybeUl) insertTarget = maybeUl;
    }
  }


  if (!insertTarget) {
    window.__pendingPC = window.__pendingPC || {};
    (window.__pendingPC[convId] ||= []).push(html);
    console.warn(`[PC] No container for conv ${convId} → buffering. Pending:`, window.__pendingPC[convId].length);
    return;
  }


  const temp = document.createElement("div");
  temp.innerHTML = html;
  const incomingLi = temp.querySelector("[data-message-id]");
  if (incomingLi) {
    const mid = incomingLi.getAttribute("data-message-id");
    if (mid && insertTarget.querySelector(`[data-message-id="${mid}"]`)) {
      console.log("↩️ Skipped duplicate mid:", mid);
    } else {
      insertTarget.insertAdjacentHTML("beforeend", html);
      console.log("✅ Appended mid:", mid || "(no-id)");
    }
  } else {
    insertTarget.insertAdjacentHTML("beforeend", html);
    console.log("✅ Appended (no data-message-id)");
  }


  const scroller = insertTarget.closest(".messages-list") || insertTarget;
  if (scroller) scroller.scrollTop = scroller.scrollHeight;
},

  set_as_seen(conv_id) {
    return this.perform("set_as_seen", { conv_id })
  }
})

window.App.private_conversation = conversationChannel
