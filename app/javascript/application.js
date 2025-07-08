import * as Turbo from "@hotwired/turbo" 
window.Turbo = Turbo

import $ from "jquery"
import * as bootstrap from "bootstrap"
import Rails from "@rails/ujs"

Rails.start()
window.$ = $
window.jQuery = $
window.bootstrap = bootstrap

import "./posts/style"
import "./posts/modal"
import "./chat_windows"
import "./toggle_window"
import "./channels"
