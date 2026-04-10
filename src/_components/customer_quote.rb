class CustomerQuote < Bridgetown::Component
  def initialize(quotes:, interval: 8000)
    @quotes = quotes
    @interval = interval
  end
end
