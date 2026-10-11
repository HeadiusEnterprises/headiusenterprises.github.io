class ServiceTier < Bridgetown::Component
  def initialize(section_id:, code:, heading:, body:, pricing:, features:, highlighted:, featured:, actions: [])
    @section_id = section_id
    @code = code
    @heading = heading
    @body = body
    @pricing = pricing
    @features = features
    @highlighted = highlighted
    @featured = featured
    @actions = actions
  end
end
