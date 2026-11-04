class Image < Bridgetown::Component
  def initialize(src:, alt: "", css_class: nil)
    @src = src
    @alt = alt
    @css_class = css_class
  end
end
