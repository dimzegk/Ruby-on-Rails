// app/javascript/channels/shared/conversation.js

// 🔍 Εντοπίζει DOM στοιχείο για τη συνομιλία
export function findConv(conversation_id, type) {
  // Αν είναι ανοιχτή η κύρια συνομιλία στον messenger
  const messengerConv = document.querySelector('body .conversation');
  if (messengerConv) {
    return messengerConv;
  } else {
    // Αν είναι popup συνομιλία
    const selector = `[data-${type}conversation-id='${conversation_id}']`;
    return document.querySelector(`body ${selector}`);
  }
}

// ✅ Ελέγχει αν η συνομιλία είναι rendered και ορατή
export function ConvRendered(conversation_id, type) {
  if (document.querySelector('body .conversation')) {
    return true;
  } else {
    const selector = `[data-${type}conversation-id='${conversation_id}']`;
    const conv = document.querySelector(`body ${selector}`);
    return conv ? conv.offsetParent !== null : false; // visible check
  }
}

// 💬 Ελέγχει αν τα μηνύματα μιας συνομιλίας είναι ορατά
export function ConvMessagesVisiblity(conversation) {
  if (document.querySelector('body .conversation')) {
    return true;
  } else if (conversation) {
    const panel = conversation.querySelector('.panel-body');
    return panel ? panel.offsetParent !== null : false;
  }
  return false;
}
