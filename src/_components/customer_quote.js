;(function () {
  function initCycler(el) {
    var quotes = el.querySelectorAll("blockquote")
    if (quotes.length < 2) return
    var interval = parseInt(el.dataset.interval, 10) || 8000
    var i = 0
    setInterval(function () {
      quotes[i].classList.remove("is-active")
      i = (i + 1) % quotes.length
      quotes[i].classList.add("is-active")
    }, interval)
  }

  function init() {
    var nodes = document.querySelectorAll("[data-customer-quote]")
    for (var i = 0; i < nodes.length; i++) initCycler(nodes[i])
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init)
  } else {
    init()
  }
})()
