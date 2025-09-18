import $ from "jquery";
document.addEventListener("turbo:load", () => {
  const $list = $('.conversation .messages-list');
  if ($list.length === 0) return;


  const $firstLink = $list.find('.js-load-more-messages').first();
  const hasMessages = $list.find('ul li').length > 0;
  if (!hasMessages && $firstLink.length && !$firstLink.data('autoloaded')) {
    $firstLink.data('autoloaded', true);
    $firstLink[0].click();
    $list.find('.loading-more-messages').hide();
  }


  const ensureScrollbar = () => {
    const needsMore = $list[0].scrollHeight <= $list.innerHeight();
    if (needsMore) {
      const $next = $list.find('.js-load-more-messages').first();
      if ($next.length) {
        $next[0].click();
        setTimeout(ensureScrollbar, 150);
      }
    }
  };
  setTimeout(ensureScrollbar, 0);
});
