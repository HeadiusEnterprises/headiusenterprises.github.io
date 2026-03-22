class ConsentEmbed < Bridgetown::Component
  attr_reader :provider, :embed_url, :link_url, :title, :background

  def initialize(provider:, embed_url:, link_url:, title:, background: nil)
    @provider = provider
    @embed_url = embed_url
    @link_url = link_url
    @title = title
    @background = background
  end
end
