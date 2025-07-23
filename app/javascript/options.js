document.addEventListener('turbo:load', function () {
  document.body.addEventListener('click', function (e) {
    const target = e.target.closest('.add-people-to-chat');
    if (!target) return;

    const selectBox = target.nextElementSibling;
    if (selectBox) {
      if (selectBox.style.display === 'none' || !selectBox.style.display) {
        selectBox.style.display = 'block';
      } else {
        selectBox.style.display = 'none';
      }
    }
  });
});
