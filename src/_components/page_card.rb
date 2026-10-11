class PageCard < Bridgetown::Component
  def initialize(title:, body: nil, image: nil, image_alt: nil, link_label: nil, link_url: nil)
    @title = title
    @body = body
    @image = image
    @image_alt = image_alt
    @link_label = link_label
    @link_url = link_url
  end
end
