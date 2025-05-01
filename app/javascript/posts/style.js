const colorSet = randomColorSet();
const mode = Math.floor(Math.random() * 2);

function styleCards() {
  const cards = document.querySelectorAll(".single-post-card");
  console.log("🎯 Found cards:", cards.length);

  cards.forEach((card) => {
    if (mode === 1) {
      card.classList.add("solid-color-mode");
      card.style.backgroundColor = randomColor();
    } else {
      card.classList.add("border-color-mode");
      card.style.border = "5px solid " + randomColor();
    }
  });
}

function bindFeedHoverEvents() {
  const feed = document.getElementById("feed");
  if (!feed) return;

  feed.addEventListener("mouseenter", function (e) {
    if (e.target.classList.contains("single-post-list")) {
      e.target.style.borderColor = randomColor();
    }
  }, true);

  feed.addEventListener("mouseleave", function (e) {
    if (e.target.classList.contains("single-post-list")) {
      e.target.style.borderColor = "rgba(0, 0, 0, 0.05)";
    }
  }, true);
}

document.addEventListener("DOMContentLoaded", () => {
  console.log("✨ style.js loaded on DOMContentLoaded");
  styleCards();
  bindFeedHoverEvents();
});

document.addEventListener("turbo:load", () => {
  console.log("🚀 style.js loaded on turbo:load");
  styleCards();
  bindFeedHoverEvents();
});

function randomColorSet() {
  const sets = [
    ['#45CCFF', '#49E83E', '#FFD432', '#E84B30', '#B243FF'],
    ['#FF6138', '#FFFF9D', '#BEEB9F', '#79BD8F', '#79BD8F'],
    ['#FCFFF5', '#D1DBBD', '#91AA9D', '#3E606F', '#193441'],
    ['#004358', '#1F8A70', '#BEDB39', '#FFE11A', '#FD7400'],
    ['#105B63', '#FFFAD5', '#FFD34E', '#DB9E36', '#BD4932'],
    ['#04BFBF', '#CAFCD8', '#F7E967', '#A9CF54', '#588F27'],
    ['#405952', '#9C9B7A', '#FFD393', '#FF974F', '#F54F29']
  ];
  return sets[Math.floor(Math.random() * sets.length)];
}

function randomColor() {
  return colorSet[Math.floor(Math.random() * colorSet.length)];
}
