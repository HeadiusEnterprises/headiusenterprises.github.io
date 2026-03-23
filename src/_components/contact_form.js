// mailto: handler for the quick contact form
window.handleContactForm = function (form) {
  var name = form.querySelector('[name="name"]').value
  var email = form.querySelector('[name="email"]').value
  var interest = form.querySelector('[name="interest"]').value
  var message = form.querySelector('[name="message"]').value

  var subject = "JRuby Support Inquiry"
  if (interest) {
    subject += " (" + interest + ")"
  }

  var body = ""
  if (name) body += "Name: " + name + "\n"
  if (email) body += "Email: " + email + "\n"
  if (interest) body += "Interested in: " + interest + "\n"
  if (message) body += "\n" + message

  var mailto =
    "mailto:support@headius.com" +
    "?subject=" + encodeURIComponent(subject) +
    "&body=" + encodeURIComponent(body)

  window.location.href = mailto
  return false
}
