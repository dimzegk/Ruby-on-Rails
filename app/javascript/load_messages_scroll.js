import $ from "jquery";
document.addEventListener('turbo:load', function () {
  var iScrollPos = 0;
  var isLoading = false;
  var currentLoadingIcon;

  $(document).ajaxComplete(function () {
    isLoading = false;
    if (currentLoadingIcon !== undefined) {
      currentLoadingIcon.hide();
    }
  });

  $('.messages-list').off('scroll').on('scroll', function () {
    var iCurScrollPos = $(this).scrollTop();

    if (iCurScrollPos < iScrollPos) {
      if (
        iCurScrollPos < 300 &&
        isLoading === false &&
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
