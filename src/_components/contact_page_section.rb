class ContactPageSection < Bridgetown::Component
  def initialize(heading:, body:, details: [])
    @heading = heading
    @body = body
    @details = details
  end
end
