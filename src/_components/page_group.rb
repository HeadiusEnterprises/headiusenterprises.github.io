class PageGroup < Bridgetown::Component
  def initialize(heading:, intro:, columns: 2, highlighted: false)
    @heading = heading
    @intro = intro
    @columns = [[columns.to_i, 1].max, 4].min
    @highlighted = highlighted
  end
end
