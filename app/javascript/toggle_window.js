document.addEventListener('turbo:load', function () {
  const panel_body = $('.panel-body');

  if (panel_body.length > 0) {
    panel_body.toggle(100, function () {
      const messages_visible = $('ul', this).has('li').length;

      if (!messages_visible && $('.load-more-messages', this).length) {
        $('.load-more-messages', this).first().trigger('click');
      }
    });
  }

  let iScrollPos = 0;
  let isLoading = false;
  let currentLoadingIcon;

  $(document).ajaxComplete(function () {
    isLoading = false;
    if (currentLoadingIcon !== undefined) {
      currentLoadingIcon.hide();
    }
  });

  $('.messages-list').off('scroll').on('scroll', function () {
    const iCurScrollPos = $(this).scrollTop();

    if (
      iCurScrollPos < iScrollPos &&
      iCurScrollPos < 300 &&
      !isLoading &&
      $('.load-more-messages', this).length
    ) {
      $('.load-more-messages', this).first().trigger('click');
      isLoading = true;

      currentLoadingIcon = $('.loading-more-messages', this);
      currentLoadingIcon.show();
    }

    iScrollPos = iCurScrollPos;
  });
});
