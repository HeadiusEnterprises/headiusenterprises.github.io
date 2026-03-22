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

  function initEmbeds() {
    var embeds = document.querySelectorAll(".consent-embed")
    for (var i = 0; i < embeds.length; i++) {
      var embed = embeds[i]
      var provider = embed.dataset.provider

      if (hasConsent(provider)) {
        loadEmbed(embed)
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
