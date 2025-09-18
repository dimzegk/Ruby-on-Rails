import $ from "jquery";
document.addEventListener("turbo:load", () => {
  $(".messenger .col-sm-2 ul").on("click", "a", function () {
    const col_2_width = $('.messenger .col-sm-2').css('width');
    const window_width = $('.messenger').width() + 'px';

    if (col_2_width === window_width) {
      console.log("📱 Mobile layout detected. Switching to messenger mobile view.");
      $('body nav').hide();
      $('.messenger .col-sm-2').hide();
      $('.messenger .col-sm-10').show();
      $('body').css('margin', '0');
      $('.messenger').css('height', '100vh');
    }
  });
});
