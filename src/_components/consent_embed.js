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

  function loadEmbed(el) {
    var url = el.dataset.embedUrl
    var iframe = document.createElement("iframe")
    iframe.src = url
    iframe.allow = "accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
    iframe.allowFullscreen = true
    el.appendChild(iframe)
    el.classList.add("consent-embed--loaded")
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

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", initEmbeds)
  } else {
    initEmbeds()
  }
})()
