class ContactForm < Bridgetown::Component
  def initialize(action: "#", method: "post", variant: "standard")
    @action = action
    @method = method
    @variant = variant
  end
end
