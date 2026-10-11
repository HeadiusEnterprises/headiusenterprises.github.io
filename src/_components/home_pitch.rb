class HomePitch < Bridgetown::Component
  def initialize(heading:, body:, secondary_body:, image:, image_alt:)
    @heading = heading
    @body = body
    @secondary_body = secondary_body
    @image = image
    @image_alt = image_alt
  end
end
