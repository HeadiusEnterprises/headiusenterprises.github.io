require "erb"
require "yaml"

root = File.expand_path("..", __dir__)
navigation = YAML.safe_load_file(File.join(root, "src", "_data", "navigation.yml"))
links = navigation.fetch("links")
menus = navigation.fetch("menus")
references = menus.fetch("header") + menus.fetch("footer").values.flatten
missing_links = references - links.keys

raise "Navigation references missing links: #{missing_links.join(', ')}" unless missing_links.empty?

home_page = File.read(File.join(root, "output", "index.html"))
menus.fetch("header").each do |id|
  link = links.fetch(id)
  expected = %(href="#{link.fetch('url')}">#{ERB::Util.html_escape(link.fetch('label'))}</a>)
  raise "Header did not render #{id} from navigation data" unless home_page.include?(expected)
end

menus.fetch("footer").each_value do |ids|
  ids.each do |id|
    link = links.fetch(id)
    external_attributes = link.fetch("url").start_with?("/") ? "" : ' target="_blank" rel="noopener"'
    expected = %(href="#{link.fetch('url')}"#{external_attributes}>#{ERB::Util.html_escape(link.fetch('label'))}</a>)
    raise "Footer did not render #{id} from navigation data" unless home_page.include?(expected)
  end
end

about_page = File.read(File.join(root, "output", "about", "index.html"))
unless about_page.include?('href="/about/" aria-current="page">About</a>')
  raise "Header did not identify the current page"
end

puts "Validated data-driven header and footer navigation"
