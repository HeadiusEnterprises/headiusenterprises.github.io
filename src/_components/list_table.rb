class ListTable < Bridgetown::Component
  def initialize(**attrs)
    @attrs = attrs
    @attrs[:class] = ["list-table", @attrs[:class]].compact.join(" ")
  end
end
