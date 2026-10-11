class ArticleGrid < Bridgetown::Component
  def initialize(section_id:, eyebrow:, heading:, articles: [], note: nil)
    @section_id = section_id
    @eyebrow = eyebrow
    @heading = heading
    @articles = articles
    @note = note
  end
end
