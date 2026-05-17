/* Ayatura landing: language, FAQ, scroll animations */
(function () {
  function detectLang() {
    try {
      const tz = Intl.DateTimeFormat().resolvedOptions().timeZone || "";
      if (/Jakarta|Pontianak|Makassar|Jayapura/i.test(tz)) return "id";
      const nav = (navigator.language || navigator.userLanguage || "en").toLowerCase();
      if (nav.startsWith("id")) return "id";
    } catch (e) {}
    return "en";
  }

  function setLang(lang) {
    const dict = I18N[lang] || I18N.en;
    document.documentElement.lang = lang;
    document.querySelectorAll("[data-i18n]").forEach((el) => {
      const key = el.getAttribute("data-i18n");
      if (dict[key] != null) el.innerHTML = dict[key];
    });
    const shots = SHOTS[lang] || SHOTS.en;
    Object.keys(shots).forEach((id) => {
      const img = document.getElementById(id);
      if (img) img.src = shots[id];
    });
    document.querySelectorAll(".lang-switch button").forEach((b) => {
      b.classList.toggle("active", b.getAttribute("data-lang") === lang);
    });
    try {
      localStorage.setItem("ayatura_lang", lang);
    } catch (e) {}
  }

  const stored = (() => {
    try {
      return localStorage.getItem("ayatura_lang");
    } catch (e) {
      return null;
    }
  })();
  const initial = stored || detectLang();
  setLang(initial);

  document.querySelectorAll(".lang-switch button").forEach((b) => {
    b.addEventListener("click", () => setLang(b.getAttribute("data-lang")));
  });

  document.querySelectorAll(".faq-item").forEach((item) => {
    item.addEventListener("toggle", () => {
      item.classList.toggle("open", item.open);
    });
  });

  const io = new IntersectionObserver(
    (entries) => {
      entries.forEach((e) => {
        if (e.isIntersecting) {
          e.target.classList.add("in");
          io.unobserve(e.target);
        }
      });
    },
    { threshold: 0.12 }
  );
  document
    .querySelectorAll("section .wrap > *, .ss-card, .step, .pillar, .widget-point")
    .forEach((el) => {
      el.classList.add("fade-in");
      io.observe(el);
    });
})();
