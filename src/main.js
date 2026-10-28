const root = document.documentElement;
const savedTheme = localStorage.getItem("theme");
if (savedTheme) root.dataset.theme = savedTheme;

const themeToggle = document.querySelector(".theme-toggle");
if (themeToggle) {
  const label = () => (root.dataset.theme === "light" ? "Dark" : "Light");
  themeToggle.textContent = label();
  themeToggle.addEventListener("click", () => {
    root.dataset.theme = root.dataset.theme === "light" ? "dark" : "light";
    localStorage.setItem("theme", root.dataset.theme);
    themeToggle.textContent = label();
  });
}

const spotlight = document.querySelector(".spotlight");
const links = [...document.querySelectorAll(".section-nav a")];
const sections = links
  .map((link) => document.querySelector(link.getAttribute("href")))
  .filter(Boolean);

window.addEventListener("pointermove", (event) => {
  if (!spotlight) return;
  spotlight.style.setProperty("--x", `${event.clientX}px`);
  spotlight.style.setProperty("--y", `${event.clientY}px`);
});

const observer = new IntersectionObserver(
  (entries) => {
    const visible = entries
      .filter((entry) => entry.isIntersecting)
      .sort((a, b) => b.intersectionRatio - a.intersectionRatio)[0];

    if (!visible) return;

    links.forEach((link) => {
      link.classList.toggle("active", link.dataset.section === visible.target.id);
    });
  },
  { rootMargin: "-35% 0px -50% 0px", threshold: [0.1, 0.25, 0.5] }
);

sections.forEach((section) => observer.observe(section));
if (links[0]) links[0].classList.add("active");
