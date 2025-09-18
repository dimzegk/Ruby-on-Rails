import Rails from "@rails/ujs";


document.addEventListener('click', function (e) {

  if (document.querySelector('.messenger')) return;


  if (window.innerWidth < 992) return;


  const a = e.target.closest('#conversations-menu li[data-type="private"] a.navlink-desktop-popup');
  if (!a) return;

  const li = a.closest('li[data-id]');
  if (!li) return;

  const convId = li.getAttribute('data-id');
  if (!convId) return;


  e.preventDefault();
  e.stopPropagation();
  if (typeof e.stopImmediatePropagation === 'function') e.stopImmediatePropagation();


  Rails.ajax({
    url: `/private/conversations/${convId}/open.js`,
    type: 'GET',
    success: () => console.log('✅ popup open.js loaded'),
    error:   (xhr) => console.error('❌ open failed', xhr && xhr.responseText),
  });
}, true); 

if (typeof window !== "undefined" && typeof positionChatWindows === "function") {
  window.positionChatWindows = positionChatWindows;
}

