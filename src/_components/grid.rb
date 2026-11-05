class Grid < Bridgetown::Component
  def initialize(columns: 3, css_class: nil)
    @columns = [[columns.to_i, 1].max, 12].min
    @css_class = css_class
  end
end
