class PageVideoGallery < Bridgetown::Component
  def initialize(heading:, intro:, section_id: "", eyebrow: "", highlighted: false, videos: [])
    @section_id = section_id
    @eyebrow = eyebrow
    @heading = heading
    @intro = intro
    @highlighted = highlighted
    @videos = videos
  end
end
