class FeatureGrid < Bridgetown::Component
  def initialize(section_id:, eyebrow:, heading:, features: [])
    @section_id = section_id
    @eyebrow = eyebrow
    @heading = heading
    @features = features
  end
end
