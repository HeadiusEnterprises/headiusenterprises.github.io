class Card < Bridgetown::Component
  def initialize(variant: nil, tag: :div, **attrs)
    @tag = tag
    @attrs = attrs
    variants = Array(variant).reject { |value| value.to_s.empty? || value == "plain" }
    @attrs[:class] = ["card", *variants].join(" ")
  end
end
