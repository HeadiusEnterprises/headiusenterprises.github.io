class Card < Bridgetown::Component
  def initialize(variant: nil, tag: :div, **attrs)
    @tag = tag
    @attrs = attrs
    @attrs[:class] = ["card", *Array(variant)].join(" ")
  end
end
