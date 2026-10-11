class PageHero < Bridgetown::Component
  def initialize(eyebrow:, heading:, body:, image: nil, image_alt: nil, actions: [])
    @eyebrow = eyebrow
    @heading = heading
    @body = body
    @image = image
    @image_alt = image_alt
    @actions = actions
  end
end
