class PageIntro < Bridgetown::Component
  def initialize(section_id:, require_path:, heading:, body:)
    @section_id = section_id
    @require_path = require_path
    @heading = heading
    @body = body
  end
end
