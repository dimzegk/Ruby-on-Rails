export function findConv(conversation_id, type) {
  const messengerConv = document.querySelector('body .conversation');
  if (messengerConv) {
    return messengerConv;
  } else {
    const selector = `[data-${type}conversation-id='${conversation_id}']`;
    return document.querySelector(`body ${selector}`);
  }
}

export function ConvRendered(conversation_id, type) {
  if (document.querySelector('body .conversation')) {
    return true;
  } else {
    const selector = `[data-${type}conversation-id='${conversation_id}']`;
    const conv = document.querySelector(`body ${selector}`);
    return conv ? conv.offsetParent !== null : false;
  }
}

export function ConvMessagesVisiblity(conversation) {
  if (document.querySelector('body .conversation')) {
    return true;
  } else if (conversation) {
    const panel = conversation.querySelector('.panel-body');
    return panel ? panel.offsetParent !== null : false;
  }
  return false;
}

