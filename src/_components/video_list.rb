class VideoList < Bridgetown::Component
  def initialize(videos: [])
    @videos = videos
  end
end
