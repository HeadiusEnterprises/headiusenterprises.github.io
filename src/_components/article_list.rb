class ArticleList < Bridgetown::Component
  def initialize(articles: [])
    @articles = articles
  end
end
