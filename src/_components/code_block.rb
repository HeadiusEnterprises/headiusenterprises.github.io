class CodeBlock < Bridgetown::Component
  def initialize(language: "plaintext", framed: true)
    @language = language
    @framed = framed
  end
end
