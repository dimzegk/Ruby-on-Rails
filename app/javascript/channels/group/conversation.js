import consumer from "../consumer"

window.App = window.App || {}
if (window.App.group_conversation && window.App.group_conversation.unsubscribe) {
  try { window.App.group_conversation.unsubscribe() } catch (e) {}
  window.App.group_conversation = null
}

const groupChannel = consumer.subscriptions.create("Group::ConversationChannel", {
  connected() { console.log("✅ Connected to Group::ConversationChannel") },
  disconnected() { console.log("❌ Disconnected from Group::ConversationChannel") },

  received(data) {
    if (!data) return
    if (data.action && data.action !== "append_message") return

    const convId = data.conversation_id || data.conv_id
    const html   = data.message || data.html
    if (!convId || !html) return

    let insertTarget =
      document.querySelector(`#group_conversation_${convId}_messages`) ||
      document.querySelector(`[data-gconversation-id="${convId}"] .messages-list ul`) ||
      document.querySelector(`[data-gconversation-id="${convId}"] .messages-list`)

    if (!insertTarget) return

    const temp = document.createElement("div")
    temp.innerHTML = html
    const incomingLi = temp.querySelector("[data-message-id]")
    if (incomingLi) {
      const mid = incomingLi.getAttribute("data-message-id")
      if (!mid || !insertTarget.querySelector(`[data-message-id="${mid}"]`)) {
        insertTarget.insertAdjacentHTML("beforeend", html)
      }
    } else {
      insertTarget.insertAdjacentHTML("beforeend", html)
    }

    const scroller =
      document.querySelector(`[data-gconversation-id="${convId}"] .messages-list`) ||
      document.querySelector(`#group_conversation_${convId}_messages`)

    if (scroller) scroller.scrollTop = scroller.scrollHeight
  },
})

window.App.group_conversation = groupChannel
