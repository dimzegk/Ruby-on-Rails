import 'gon'; // αν χρησιμοποιείς το gem 'gon'

document.addEventListener('turbo:load', function () {
  let chat_windows_count = document.querySelectorAll('.conversation-window').length;

  if (gon.last_visible_chat_window == null && chat_windows_count > 0) {
    gon.last_visible_chat_window = chat_windows_count;
  }

  if (gon.hidden_chats == null) {
    gon.hidden_chats = 0;
  }

  window.addEventListener('resize', hideShowChatWindow);

  positionChatWindows();
  hideShowChatWindow();
});

function positionChatWindows() {
  const windows = document.querySelectorAll('.conversation-window');
  let chat_windows_count = windows.length;

  if (gon.hidden_chats + gon.last_visible_chat_window !== chat_windows_count) {
    if (gon.hidden_chats === 0) {
      gon.last_visible_chat_window = chat_windows_count;
    }
  }

  windows.forEach((chatWindow, i) => {
    let right_position = i * 410;
    chatWindow.style.position = 'fixed';
    chatWindow.style.bottom = '0';
    chatWindow.style.right = `${right_position}px`;
    chatWindow.style.width = '400px';
    chatWindow.style.zIndex = '1000';
    chatWindow.style.display = 'initial'; // ensure it's visible
  });
}


function hideShowChatWindow() {
  let all = document.querySelectorAll('.conversation-window');
  if (all.length < 1) return;

  let currentWindow = document.querySelector(`.conversation-window:nth-of-type(${gon.last_visible_chat_window})`);
  if (!currentWindow) return;

  let offset = currentWindow.getBoundingClientRect();

  if (offset.left < 50 && gon.last_visible_chat_window !== 1) {
    currentWindow.style.display = 'none';
    gon.hidden_chats++;
    gon.last_visible_chat_window--;
  }

  if (offset.left > 550 && gon.hidden_chats !== 0) {
    gon.hidden_chats--;
    gon.last_visible_chat_window++;
    document.querySelector(`.conversation-window:nth-of-type(${gon.last_visible_chat_window})`)
      ?.style.setProperty('display', 'initial');
  }
}
