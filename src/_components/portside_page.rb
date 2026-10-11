class PortsidePage < Bridgetown::Component
  attr_reader :components

  def initialize(components:)
    @components = Array(components)
  end

  def component_for(definition)
    type = definition.fetch("type")
    component_class = Object.const_get(type)
    unless component_class < Bridgetown::Component
      raise ArgumentError, "#{type} is not a Bridgetown component"
    end

    component_class.new(**deep_symbolize(definition.fetch("values", {})))
  end

  private

  def deep_symbolize(value)
    case value
    when Hash
      value.to_h { |key, child| [key.to_sym, deep_symbolize(child)] }
    when Array
      value.map { |child| deep_symbolize(child) }
    else
      value
    end
  end
end
