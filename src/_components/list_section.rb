class ListSection < Bridgetown::Component
  def initialize(section_id:, eyebrow:, heading:, intro:, highlighted:, items: [], note: nil, note_class: nil)
    @section_id = section_id
    @eyebrow = eyebrow
    @heading = heading
    @intro = intro
    @highlighted = highlighted
    @items = items
    @note = note
    @note_class = note_class
  end
end
