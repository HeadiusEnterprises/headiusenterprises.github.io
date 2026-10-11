class HomeHero < Bridgetown::Component
  def initialize(require_path:, heading:, subheading_prefix:, subheading_highlight:, body:, image:, image_alt:, actions: [])
    @require_path = require_path
    @heading = heading
    @subheading_prefix = subheading_prefix
    @subheading_highlight = subheading_highlight
    @body = body
    @image = image
    @image_alt = image_alt
    @actions = actions
  end
end
