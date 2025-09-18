import Rails from "@rails/ujs";

console.log("📨 send_message.js loaded");

(function setupOnce() {
  if (window.__SEND_MSG_BOUND__) return;
  window.__SEND_MSG_BOUND__ = true;


  document.body.addEventListener(
    "click",
    (e) => {
      const btn = e.target.closest(
        ".send-private-message .send-message, .send-group-message .send-message"
      );
      if (!btn) return;
      const form = btn.closest(
        "form.send-private-message, form.send-group-message"
      );
      if (form) form.requestSubmit();
    },
    true
  );


  document.addEventListener(
    "keydown",
    (event) => {
      const textarea = event.target.closest(
        ".send-private-message textarea, .send-group-message textarea"
      );
      if (!textarea) return;
      if (event.key === "Enter" && !event.shiftKey) {
        event.preventDefault();
        const form = textarea.closest(
          "form.send-private-message, form.send-group-message"
        );
        if (form && textarea.value.trim() !== "") form.requestSubmit();
      }
    },
    true
  );
  document.body.addEventListener(
    "submit",
    (e) => {
      const form = e.target.closest(
        "form.send-private-message, form.send-group-message"
      );
      if (!form) return;

      e.preventDefault();
      e.stopPropagation();

      form.setAttribute("data-turbo", "false"); 

      const textarea = form.querySelector('textarea[name="body"]');
      const payloadText = textarea ? textarea.value.trim() : "";
      if (!payloadText) return;


      if (form.getAttribute("data-submitting") === "1") return;
      form.setAttribute("data-submitting", "1");

      const submitBtn = form.querySelector(".send-message");
      if (submitBtn) submitBtn.disabled = true;

      const fd = new FormData(form);
      const payload = new URLSearchParams([...fd]).toString();

      const action = form.getAttribute("action");
      if (!action) {
        console.error("❌ Missing form action (nested conversation messages path).");
        if (submitBtn) submitBtn.disabled = false;
        form.removeAttribute("data-submitting");
        return;
      }

      Rails.ajax({
        url: action,
        type: "POST",
        data: payload,
        headers: {
          Accept: "text/html,application/xhtml+xml,application/xml", 
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')?.content,
        },
        success: function () {
          if (textarea) textarea.value = "";
          if (submitBtn) submitBtn.disabled = false;
          form.removeAttribute("data-submitting");

          const sc =
            form
              .closest(".panel-body, .conversation, #messenger-pane")
              ?.querySelector(".messages-list") ||
            document.querySelector(
              form.classList.contains("send-private-message")
                ? `#conversation_${form.dataset?.conversationId}_messages`
                : `#group_conversation_${form.dataset?.groupConversationId}_messages`
            );
          if (sc) sc.scrollTop = sc.scrollHeight;
        },
        error: function (xhr) {
          console.error("❌ Message send failed", xhr && xhr.responseText);
          if (submitBtn) submitBtn.disabled = false;
          form.removeAttribute("data-submitting");
        },
      });
    },
    true
  );
})();
