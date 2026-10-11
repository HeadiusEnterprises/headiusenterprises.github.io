class CallToActionSection < Bridgetown::Component
  def initialize(section_id:, eyebrow:, heading:, body:, highlighted:, actions: [])
    @section_id = section_id
    @eyebrow = eyebrow
    @heading = heading
    @body = body
    @highlighted = highlighted
    @actions = actions
  end
end
