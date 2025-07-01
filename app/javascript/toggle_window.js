document.addEventListener('turbo:load', function () {
  document.body.addEventListener('click', function (e) {
    if (
      e.target.closest('.conversation-heading') ||
      e.target.closest('.conversation-heading-full')
    ) {
      e.preventDefault();

      const panel = e.target.closest('.panel');
      const panelBody = panel.querySelector('.panel-body');

      if (panelBody) {
        $(panelBody).toggle(100, function () {
          const messagesVisible = $('ul', this).has('li').length;

          if (!messagesVisible && $('.load-more-messages', this).length) {
            $('.load-more-messages', this)[0].click();
          }
        });
      }
    }
  });
});
