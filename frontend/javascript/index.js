import "$styles/index.css"
import "$styles/syntax-highlighting.css"

// Import all JavaScript & CSS files from src/_components
import components from "$components/**/*.{js,jsx,js.rb,css}"

// Scroll-to buttons
document.addEventListener("click", function (e) {
  var target = e.target.closest("[data-scroll-to]")
  if (target) {
    var el = document.getElementById(target.dataset.scrollTo)
    if (el) el.scrollIntoView({ behavior: "smooth" })
  }
})

// Theme switcher
;(function () {
  var switcher = document.getElementById("theme-switcher")
  if (!switcher) return

  var icon = document.getElementById("theme-icon")
  var options = switcher.querySelectorAll("menu li")
  var saved = localStorage.getItem("headius-theme") || "auto"

  var icons = { auto: "◑", dark: "☽", light: "☀", "high-contrast": "◉" }

  function resolveTheme(mode) {
    if (mode === "auto") {
      return window.matchMedia("(prefers-color-scheme: light)").matches
        ? "light"
        : "dark"
    }
    return mode
  }

  function applyTheme(mode) {
    var resolved = resolveTheme(mode)
    if (resolved === "dark") {
      document.documentElement.removeAttribute("data-theme")
    } else {
      document.documentElement.setAttribute("data-theme", resolved)
    }
    icon.textContent = icons[mode]
    for (var i = 0; i < options.length; i++) {
      options[i].classList.toggle("active", options[i].dataset.theme === mode)
    }
  }

  applyTheme(saved)

  switcher.addEventListener("mouseenter", function () {
    switcher.classList.add("open")
  })

  switcher.addEventListener("mouseleave", function () {
    switcher.classList.remove("open")
  })

  icon.addEventListener("click", function () {
    switcher.classList.toggle("open")
  })

  for (var i = 0; i < options.length; i++) {
    options[i].addEventListener("click", function () {
      saved = this.dataset.theme
      localStorage.setItem("headius-theme", saved)
      applyTheme(saved)
      switcher.classList.remove("open")
    })
  }

  document.addEventListener("click", function (e) {
    if (!switcher.contains(e.target)) {
      switcher.classList.remove("open")
    }
  })

  window
    .matchMedia("(prefers-color-scheme: light)")
    .addEventListener("change", function () {
      if (saved === "auto") {
        applyTheme("auto")
      }
    })
})()

// Easter egg: triple-click the horns
;(function () {
  var metal = document.querySelector(".metal")
  if (!metal) return

  var clicks = []

  metal.addEventListener("click", function () {
    var now = Date.now()
    clicks.push(now)
    // Keep only clicks within the last second
    clicks = clicks.filter(function (t) { return now - t < 1000 })
    if (clicks.length >= 3) {
      clicks = []
      horns()
    }
  })

  function horns() {
    var el = document.createElement("div")
    el.textContent = "\\m/"
    el.style.cssText =
      "position:fixed;inset:0;display:flex;align-items:center;justify-content:center;" +
      "font-family:var(--mono);font-size:2rem;color:var(--crimson-light);z-index:9999;" +
      "pointer-events:none;background:var(--void);opacity:0;"
    document.body.appendChild(el)

    // Grow in
    requestAnimationFrame(function () {
      el.style.transition = "font-size 0.6s ease-out, opacity 0.3s"
      el.style.opacity = "1"
      el.style.fontSize = "30vw"
    })

    // Fade out
    setTimeout(function () {
      el.style.transition = "opacity 1s ease-out"
      el.style.opacity = "0"
    }, 1000)

    // Remove
    setTimeout(function () {
      el.remove()
    }, 2100)
  }
})()
