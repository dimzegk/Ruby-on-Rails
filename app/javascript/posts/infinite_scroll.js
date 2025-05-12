document.addEventListener('turbo:load', function() {
    let isLoading = false;
  
    if (document.querySelector('.infinite-scroll')) {
      window.addEventListener('scroll', function () {
        const nextPageLink = document.querySelector('.pagination a.next_page');
        if (!nextPageLink) return;
  
        const threshold = document.documentElement.scrollHeight - window.innerHeight - 60;
        if (!isLoading && window.scrollY > threshold) {
          isLoading = true;
          $.getScript(nextPageLink.href)
            .done(() => { isLoading = false; })
            .fail(() => { isLoading = false; });
        }
      });
    }
  });
  