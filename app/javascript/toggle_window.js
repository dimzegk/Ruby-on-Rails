panel_body.toggle(100, function() {
  var messages_visible = $('ul', this).has('li').length;

  // Αν η λίστα μηνυμάτων είναι κενή και υπάρχει κουμπί "load more"
  if (!messages_visible && $('.load-more-messages', this).length) {
    $('.load-more-messages', this)[0].click(); 
  }
});

$(document).on('turbolinks:load ajax:complete', function() {
  var iScrollPos = 0;
  var isLoading = false;
  var currentLoadingIcon;

  $(document).ajaxComplete(function() {
    isLoading = false;

    // Απόκρυψη loading icon
    if (currentLoadingIcon !== undefined) {
      currentLoadingIcon.hide();
    }
  });

  $('.messages-list').on('scroll', function () {
    var iCurScrollPos = $(this).scrollTop();

    // Αν ο χρήστης σκρολάρει προς τα πάνω
    if (iCurScrollPos < iScrollPos) {
      if (
        iCurScrollPos < 300 &&
        !isLoading &&
        $('.load-more-messages', this).length
      ) {
        $('.load-more-messages', this)[0].click();
        isLoading = true;

        currentLoadingIcon = $('.loading-more-messages', this);
        currentLoadingIcon.show();
      }
    }

    iScrollPos = iCurScrollPos;
  });
});
