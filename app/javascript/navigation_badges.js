export function updateNavBadges() {
  const convBadge = document.getElementById("unseen-conversations");
  const reqBadge  = document.getElementById("unresponded-contact-requests");

  const unseenCount = document.querySelectorAll("#conversations-list .unseen-conv").length;
  if (convBadge) {
    if (unseenCount > 0) {
      convBadge.classList.remove("d-none");
      convBadge.textContent = unseenCount;
    } else {
      convBadge.classList.add("d-none");
      convBadge.textContent = "";
    }
  }


  const reqCount = document.querySelectorAll("#contact-requests-list .contact-request").length;
  if (reqBadge) {
    if (reqCount > 0) {
      reqBadge.classList.remove("d-none");
      reqBadge.textContent = reqCount;
    } else {
      reqBadge.classList.add("d-none");
      reqBadge.textContent = "";
    }
  }
}

document.addEventListener("turbo:load", updateNavBadges);
window.updateNavBadges = updateNavBadges;
