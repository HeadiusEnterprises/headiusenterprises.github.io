class HomeContact < Bridgetown::Component
  def initialize(section_id: "contact", highlighted: false, heading:, body:, details: [])
    @section_id = section_id
    @highlighted = highlighted
    @heading = heading
    @body = body
    @details = details
  end
end
