document.addEventListener('turbo:load', function() {
  const panel_body = $('.panel-body');

  panel_body.toggle(100, function() {
    const messages_visible = $('ul', this).has('li').length;

    // Αν η λίστα μηνυμάτων είναι κενή και υπάρχει κουμπί "load more"
    if (!messages_visible && $('.load-more-messages', this).length) {
      $('.load-more-messages', this)[0].click(); 
    }
  });

  let iScrollPos = 0;
  let isLoading = false;
  let currentLoadingIcon;

  $(document).ajaxComplete(function() {
    isLoading = false;

    // Απόκρυψη loading icon
    if (currentLoadingIcon !== undefined) {
      currentLoadingIcon.hide();
    }
  });

  $('.messages-list').on('scroll', function () {
    const iCurScrollPos = $(this).scrollTop();

    // Αν ο χρήστης σκρολάρει προς τα πάνω
    if (
      iCurScrollPos < iScrollPos &&
      iCurScrollPos < 300 &&
      !isLoading &&
      $('.load-more-messages', this).length
    ) {
      $('.load-more-messages', this)[0].click();
      isLoading = true;

      currentLoadingIcon = $('.loading-more-messages', this);
      currentLoadingIcon.show();
    }

    iScrollPos = iCurScrollPos;
  });
});
