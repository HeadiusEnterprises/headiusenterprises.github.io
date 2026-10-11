class TeamSection < Bridgetown::Component
  def initialize(section_id:, eyebrow:, heading:, people: [])
    @section_id = section_id
    @eyebrow = eyebrow
    @heading = heading
    @people = people
  end
end
