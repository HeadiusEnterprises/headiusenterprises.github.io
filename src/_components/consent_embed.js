// Consent-gated embed loader
// Stores consent as comma-separated providers in localStorage "headius-consent"
;(function () {
  var STORAGE_KEY = "headius-consent"

  function getConsent() {
    var raw = localStorage.getItem(STORAGE_KEY)
    return raw ? raw.split(",") : []
  }

  function addConsent(provider) {
    var consented = getConsent()
    if (consented.indexOf(provider) === -1) {
      consented.push(provider)
      localStorage.setItem(STORAGE_KEY, consented.join(","))
    }
  }

  function hasConsent(provider) {
    return getConsent().indexOf(provider) !== -1
  }

  function getThemeBgColor() {
    return getComputedStyle(document.documentElement).getPropertyValue("--surface").trim()
  }

  function embedUrl(baseUrl, el) {
    if (!isFormEmbed(el)) return baseUrl
    var hex = getThemeBgColor()
    // Convert hex to rgb() format for Google Forms bgcolor param
    var r = parseInt(hex.slice(1, 3), 16)
    var g = parseInt(hex.slice(3, 5), 16)
    var b = parseInt(hex.slice(5, 7), 16)
    var sep = baseUrl.indexOf("?") !== -1 ? "&" : "?"
    return baseUrl + sep + "bgcolor=rgb(" + r + "," + g + "," + b + ")"
  }

  function loadEmbed(el) {
    if (el.dataset.scriptUrl) {
      loadScriptEmbed(el)
      return
    }
    var url = embedUrl(el.dataset.embedUrl, el)
    var iframe = document.createElement("iframe")
    iframe.src = url
    iframe.allow = "accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
    iframe.allowFullscreen = true
    el.appendChild(iframe)
    el.classList.add("consent-embed--loaded")
  }

  function loadScriptEmbed(el) {
    var tmpl = el.querySelector("template.consent-embed__template")
    if (tmpl) {
      el.appendChild(tmpl.content.cloneNode(true))
      tmpl.remove()
    }
    el.classList.add("consent-embed--loaded")

    var scriptUrl = el.dataset.scriptUrl
    var selector = 'script[data-consent-script="' + scriptUrl + '"]'
    if (!document.querySelector(selector)) {
      var s = document.createElement("script")
      s.src = scriptUrl
      s.async = true
      s.setAttribute("charset", "UTF-8")
      s.setAttribute("data-consent-script", scriptUrl)
      document.body.appendChild(s)
    }
  }

  function isFormEmbed(el) {
    return el.classList.contains("consent-embed--form")
  }

  function openFullscreen(el) {
    var overlay = document.createElement("div")
    overlay.className = "consent-embed__overlay"

    var close = document.createElement("button")
    close.className = "consent-embed__close"
    close.setAttribute("aria-label", "Close fullscreen form")
    close.innerHTML = "×"
    close.addEventListener("click", function () {
      overlay.remove()
    })

    // Move the iframe into the overlay
    var iframe = el.querySelector("iframe")
    var clone = iframe.cloneNode(true)
    overlay.appendChild(clone)
    overlay.appendChild(close)
    document.body.appendChild(overlay)
  }

  function addExpandButton(el) {
    var btn = document.createElement("button")
    btn.className = "consent-embed__expand"
    btn.setAttribute("aria-label", "Expand form")
    btn.innerHTML = "⛶"
    btn.addEventListener("click", function () {
      openFullscreen(el)
    })
    el.appendChild(btn)
  }

  function initEmbeds() {
    var embeds = document.querySelectorAll(".consent-embed")
    for (var i = 0; i < embeds.length; i++) {
      var embed = embeds[i]
      var provider = embed.dataset.provider

      if (hasConsent(provider)) {
        loadEmbed(embed)
        if (isFormEmbed(embed)) {
          addExpandButton(embed)
        }
      } else {
        (function (el, prov) {
          var play = el.querySelector(".consent-embed__play")
          if (play) {
            play.addEventListener("click", function (e) {
              e.preventDefault()
              addConsent(prov)
              // Load all embeds for this provider
              var all = document.querySelectorAll(
                '.consent-embed[data-provider="' + prov + '"]'
              )
              for (var j = 0; j < all.length; j++) {
                loadEmbed(all[j])
                if (isFormEmbed(all[j])) {
                  addExpandButton(all[j])
                  openFullscreen(all[j])
                }
              }
            })
          }
        })(embed, provider)
      }
    }
  }

  function updateFormBgColors() {
    var forms = document.querySelectorAll(".consent-embed--form.consent-embed--loaded")
    for (var i = 0; i < forms.length; i++) {
      var el = forms[i]
      var iframes = el.querySelectorAll("iframe")
      for (var j = 0; j < iframes.length; j++) {
        iframes[j].src = embedUrl(el.dataset.embedUrl, el)
      }
      // Also update any fullscreen overlay clones
      var overlay = document.querySelector(".consent-embed__overlay iframe")
      if (overlay) {
        overlay.src = embedUrl(el.dataset.embedUrl, el)
      }
    }
  }

  function watchTheme() {
    var observer = new MutationObserver(function (mutations) {
      for (var i = 0; i < mutations.length; i++) {
        if (mutations[i].attributeName === "data-theme") {
          updateFormBgColors()
          return
        }
      }
    })
    observer.observe(document.documentElement, { attributes: true })
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", function () {
      initEmbeds()
      watchTheme()
    })
  } else {
    initEmbeds()
    watchTheme()
  }
})()
