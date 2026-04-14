// Character count for message textarea
document.addEventListener("DOMContentLoaded", function () {
  document.querySelectorAll(".message-wrap textarea").forEach(function (textarea) {
    var counter = textarea.parentElement.querySelector(".char-count")
    var max = parseInt(textarea.getAttribute("maxlength"), 10)
    var threshold = max - 100

    textarea.addEventListener("input", function () {
      var len = textarea.value.length
      if (len >= threshold) {
        counter.textContent = len + " / " + max
        counter.hidden = false
      } else {
        counter.hidden = true
      }
    })
  })
})

// mailto: handler for contact / inquiry forms
window.handleContactForm = function (form) {
  var fields = [
    ["name", "Name"],
    ["company", "Company"],
    ["role", "Role"],
    ["interest", "Interested in"],
    ["timeline", "Timeline"]
  ]

  var interestEl = form.querySelector('[name="interest"]')
  var interest = interestEl ? interestEl.value : ""
  var subject = "JRuby Support Inquiry"
  if (interest) subject += " (" + interest + ")"

  var body = ""
  fields.forEach(function (f) {
    var el = form.querySelector('[name="' + f[0] + '"]')
    if (el && el.value) body += f[1] + ": " + el.value + "\n"
  })

  var messageEl = form.querySelector('[name="message"]')
  if (messageEl && messageEl.value) body += "\n" + messageEl.value

  var mailto =
    "mailto:support@headius.com" +
    "?subject=" + encodeURIComponent(subject) +
    "&body=" + encodeURIComponent(body)

  window.location.href = mailto
  return false
}
