document.addEventListener('turbo:load', function () {
    console.log("✅ modal.js loaded (Bootstrap 5)");
  
    const modalEl = document.querySelector('.myModal');
    if (!modalEl) return;
  
    const modal = new bootstrap.Modal(modalEl);
  
    document.querySelectorAll('.single-post-card, .single-post-list').forEach(card => {
      card.addEventListener('click', () => {
        const posted_by = card.querySelector('.post-content .posted-by')?.textContent || '';
        const post_heading = card.querySelector('.post-content h3')?.textContent || '';
        const post_content = card.querySelector('.post-content p')?.textContent || '';
        const interested = card.querySelector('.post-content .interested')?.getAttribute('href') || '#';
  
        modalEl.querySelector('.modal-header .posted-by').textContent = posted_by;
        modalEl.querySelector('.loaded-data h3').textContent = post_heading;
        modalEl.querySelector('.loaded-data p').textContent = post_content;
        modalEl.querySelector('.loaded-data .interested a').setAttribute('href', interested);
  
        modal.show();
      });
    });
  });
  