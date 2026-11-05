class CodeBlock < Bridgetown::Component
  SIZES = %w[small medium large].freeze

  def initialize(language: "plaintext", framed: true, size: "medium")
    @language = language
    @framed = framed
    @size = SIZES.include?(size.to_s) ? size.to_s : "medium"
  end
end
