import * as Turbo from "@hotwired/turbo";
window.Turbo = Turbo;

import $ from "jquery";
import * as bootstrap from "bootstrap";
import Rails from "@rails/ujs";


Rails.start();
window.$ = $;
window.jQuery = $;
window.bootstrap = bootstrap;

console.log("🚀 app boot");


(async () => {
  await import("./posts/style");
  await import("./posts/modal");
  await import("./chat_windows");
  await import("./toggle_window");
  await import("./channels"); 
  await import("./conversations/conversation");
  await import("./load_messages_scroll");
  await import("./options");
  await import("./messenger/auto_load_previous");
  await import("./messenger/mobile_view");
  await import("./contact_requests");
  await import("./messenger/send_message");
  await import("./navigation_badges");
})();
