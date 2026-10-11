class TermsSection < Bridgetown::Component
  def initialize(section_id:, eyebrow:, heading:, terms: [])
    @section_id = section_id
    @eyebrow = eyebrow
    @heading = heading
    @terms = terms
  end
end
