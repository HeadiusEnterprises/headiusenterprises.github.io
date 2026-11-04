class SupportPlan < Bridgetown::Component
  def initialize(name:, inheritance:, body:, features:, link_label:, link_url:, featured: false)
    @name = name
    @inheritance = inheritance
    @body = body
    @features = features
    @link_label = link_label
    @link_url = link_url
    @featured = featured
  end
end
