import Rails from "@rails/ujs";

console.log("💬 conversations/conversation.js loaded");

(function setupOnce() {
  if (window.__CONV_JS_BOUND__) return;
  window.__CONV_JS_BOUND__ = true;
  document.body.addEventListener("submit", (e) => {
    const form = e.target.closest("form.send-private-message, form.send-group-message");
    if (!form) return;

    e.preventDefault();
    e.stopPropagation();

    const textarea = form.querySelector('textarea[name="body"]');
    const text = textarea ? textarea.value.trim() : "";
    if (!text) return;
    if (form.getAttribute("data-submitting") === "1") return;
    form.setAttribute("data-submitting", "1");

    const submitBtn = form.querySelector(".send-message");
    if (submitBtn) submitBtn.disabled = true;

    const fd = new FormData(form);
    const payload = new URLSearchParams([...fd]).toString();

    const action = form.getAttribute("action");
    if (!action) {
      console.error("❌ Missing form action (nested conversation messages path). Fix the form_with URL.");
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
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')?.content
      },
      success: function () {
        if (textarea) textarea.value = "";
        if (submitBtn) submitBtn.disabled = false;
        form.removeAttribute("data-submitting");
      },
      error: function (xhr) {
        console.error("❌ Message send failed", xhr && xhr.responseText);
        if (submitBtn) submitBtn.disabled = false;
        form.removeAttribute("data-submitting");
      },
    });
  }, true);
})();
