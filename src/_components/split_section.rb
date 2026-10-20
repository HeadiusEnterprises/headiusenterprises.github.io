class SplitSection < Bridgetown::Component
  def initialize(section_id:, eyebrow:, heading:, highlighted: false)
    @section_id = section_id
    @eyebrow = eyebrow
    @heading = heading
    @highlighted = highlighted
  end
end
