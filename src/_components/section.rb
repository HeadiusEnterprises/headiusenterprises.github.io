class Section < Bridgetown::Component
  def initialize(section_id:, highlighted: false)
    @section_id = section_id
    @highlighted = highlighted
  end
end
