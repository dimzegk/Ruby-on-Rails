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
        if (panelBody.style.display === 'none') {
          panelBody.style.display = 'block';
        } else {
          panelBody.style.display = 'none';
        }
      }
    }
  });
});
