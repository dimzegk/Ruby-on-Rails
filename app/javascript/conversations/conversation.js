document.addEventListener('turbo:load', () => {
  // αφήνουμε κενό στο scroll για τα νέα μηνύματα
  document.querySelectorAll('.messages-list').forEach(el => {
    el.scrollTop = 500;
  });

  document.addEventListener('keydown', function (event) {
    const isInConversation = event.target.closest('.conversation-window, .conversation');
    if (!isInConversation) return;

    if (event.key === 'Enter' && !event.shiftKey) {
      const textarea = event.target;
      const form = textarea.closest('form');
      const body = textarea.value.trim();

      if (body !== "") {
        form.requestSubmit(); // trigger submit
        textarea.value = ""; // clear textarea
        event.preventDefault();
      }
    }
  });
});

// θα το χρησιμοποιήσουμε αργότερα
export function calculateUnseenConversations() {
  const unseenConvCount = document.querySelectorAll('#conversations-menu .unseen-conv').length;
  const badge = document.getElementById('unseen-conversations');

  if (unseenConvCount && badge) {
    badge.style.visibility = 'visible';
    badge.textContent = unseenConvCount;
  } else if (badge) {
    badge.style.visibility = 'hidden';
    badge.textContent = '';
  }
}
