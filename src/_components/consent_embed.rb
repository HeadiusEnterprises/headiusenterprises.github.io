class ConsentEmbed < Bridgetown::Component
  attr_reader :provider, :embed_url, :link_url, :title, :background, :script_url, :variant

  PRIVACY_URLS = {
    "YouTube" => "https://policies.google.com/privacy",
    "Reddit"  => "https://www.reddit.com/policies/privacy-policy"
  }.freeze

  def initialize(provider:, link_url:, title:, embed_url: nil, background: nil, script_url: nil, variant: nil, privacy_url: nil)
    @provider = provider
    @embed_url = embed_url
    @link_url = link_url
    @title = title
    @background = background
    @script_url = script_url
    @variant = variant
    @privacy_url = privacy_url
  end

  def privacy_url
    @privacy_url || PRIVACY_URLS[provider] || "#"
  end

  def play_label
    provider == "YouTube" ? "Play video: #{title}" : "Load #{provider} embed: #{title}"
  end

  def link_label
    provider == "YouTube" ? "Watch on YouTube" : "View on #{provider}"
  end
end
