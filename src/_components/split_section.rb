class SplitSection < Bridgetown::Component
  def initialize(section_id:, eyebrow:, heading:, left_body:, right_body:, highlighted: false)
    @section_id = section_id
    @eyebrow = eyebrow
    @heading = heading
    @left_body = left_body
    @right_body = right_body
    @highlighted = highlighted
  end
end
