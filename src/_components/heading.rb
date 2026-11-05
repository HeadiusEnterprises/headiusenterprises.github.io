class Heading < Bridgetown::Component
  def initialize(text:, level: 2)
    @text = text
    @level = [[level.to_i, 1].max, 6].min
  end
end
