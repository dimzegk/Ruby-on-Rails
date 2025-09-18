# config/initializers/content_security_policy.rb
Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self, :https
    policy.font_src    :self, :https, :data
    policy.img_src     :self, :https, :data
    policy.object_src  :none

    # Dev-friendly: επιτρέπουμε inline & eval για να παίζουν GON, inline scripts κλπ.
    policy.script_src  :self, :https, :unsafe_inline, :unsafe_eval
    policy.style_src   :self, :https, :unsafe_inline

    # WebSockets για ActionCable στον dev
    policy.connect_src :self, :https, :http,
                       "ws://localhost:3000",
                       "ws://127.0.0.1:3000"
  end

  # ΜΗ βάζεις nonces σε dev — απλά άστα απενεργοποιημένα:
  # config.content_security_policy_nonce_generator = ->(request) { request.session.id.to_s }
  # config.content_security_policy_nonce_directives = %w(script-src style-src)

  # Εναλλακτικά, για λίγο, μπορείς να το βάλεις μόνο report (δεν μπλοκάρει):
  # config.content_security_policy_report_only = true
end
