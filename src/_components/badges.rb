class Badges < Bridgetown::Component
  def initialize(**attrs)
    @attrs = attrs
    @attrs[:class] = ["badges", @attrs[:class]].compact.join(" ")
  end
end
