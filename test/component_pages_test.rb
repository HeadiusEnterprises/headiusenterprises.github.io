require "yaml"

MAIN_PAGES = %w[index services about resources blog contact privacy].freeze
config = YAML.safe_load_file(File.expand_path("../.portside/components.yml", __dir__))
component_types = config.fetch("components").keys

MAIN_PAGES.each do |page|
  source = File.read(File.expand_path("../src/#{page}.erb", __dir__))
  frontmatter, body = source.split("---", 3).drop(1)
  rendered_types = body.scan(/<%=\s*render\s+(\w+)\.new/).flatten

  raise "#{page} is not a Portside component page" unless frontmatter.include?("portside: components")
  raise "#{page} does not render a component" if rendered_types.empty?

  unknown_types = rendered_types - component_types
  raise "#{page} renders unconfigured components: #{unknown_types.join(', ')}" unless unknown_types.empty?
  raise "#{page} still contains a raw top-level section" if body.match?(/^<section\b/)
end

puts "Validated #{MAIN_PAGES.length} component pages"
