document.addEventListener('turbo:load', function () {
  const chatWindows = document.querySelectorAll('.conversation-window');

  if (gon.last_visible_chat_window == null && chatWindows.length > 0) {
    gon.last_visible_chat_window = chatWindows.length;
  }

  if (gon.hidden_chats == null) {
    gon.hidden_chats = 0;
  }

  window.addEventListener('resize', hideShowChatWindow);

  positionChatWindows();
  hideShowChatWindow();
});

function positionChatWindows() {
  const windows = Array.from(document.querySelectorAll('.conversation-window'))
    .filter(win => win.offsetParent !== null);

  windows.forEach((chatWindow, index) => {
    chatWindow.style.position = 'fixed';
    chatWindow.style.bottom = '0';
    chatWindow.style.right = `${index * 410}px`;
    chatWindow.style.width = '400px';
    chatWindow.style.zIndex = '1000';
    chatWindow.style.display = 'initial';
  });

  gon.last_visible_chat_window = windows.length;
}

function hideShowChatWindow() {
  const windows = document.querySelectorAll('.conversation-window');
  if (windows.length < 1) return;

  const lastIndex = gon.last_visible_chat_window - 1;
  const currentWindow = windows[lastIndex];
  if (!currentWindow) return;

  const offset = currentWindow.getBoundingClientRect();

  if (offset.left < 50 && gon.last_visible_chat_window !== 1) {
    currentWindow.style.display = 'none';
    gon.hidden_chats++;
    gon.last_visible_chat_window--;
  }

  if (offset.left > 550 && gon.hidden_chats !== 0) {
    gon.hidden_chats--;
    gon.last_visible_chat_window++;
    const nextWindow = windows[gon.last_visible_chat_window - 1];
    if (nextWindow) nextWindow.style.display = 'initial';
  }
}
