class ContactForm < Bridgetown::Component
  def initialize(action: "#", method: "post")
    @action = action
    @method = method
  end
end
