require "bridgetown"
require "erb"
require_relative "../src/_components/actions"
require_relative "../src/_components/code_block"
require_relative "../src/_components/contact_form"
require_relative "../src/_components/disclosure_list"
require_relative "../src/_components/grid"
require_relative "../src/_components/image"
require_relative "../src/_components/columns"

def render_component(component, template, content: "")
  component.define_singleton_method(:content) { content }
  component.define_singleton_method(:url_for) { |url| "/resolved#{url}" }
  component.define_singleton_method(:markdownify) { |markdown| markdown }
  ERB.new(File.read(template), trim_mode: "-").result(component.instance_eval { binding })
end

components = File.expand_path("../src/_components", __dir__)

actions = Actions.new(actions: [
  { label: "Plans", url: "/services", style: "primary", new_window: false },
  { label: "Contact", url: "https://example.com", style: "ghost", new_window: true },
  { label: "Packages", target: "packages", style: "primary" }
])
actions_html = render_component(actions, File.join(components, "actions.erb"))
unless actions_html.include?('<a href="/resolved/services" class="button">Plans</a>') &&
       actions_html.include?('class="button ghost" target="_blank" rel="noopener">Contact</a>') &&
       actions_html.include?('<button class="button" data-scroll-to="packages">Packages</button>')
  raise "Actions did not render links and scroll buttons"
end

grid = Grid.new(columns: 20, css_class: "plans")
grid_html = render_component(grid, File.join(components, "grid.erb"), content: "<div>Plan</div>")
unless grid_html.include?('class="component-grid plans"') &&
       grid_html.include?('style="--grid-columns: 12"') &&
       grid_html.include?("<div>Plan</div>")
  raise "Grid did not render its layout and children"
end

image = Image.new(src: "/images/logo.svg", alt: "Logo", css_class: "brand")
image_html = render_component(image, File.join(components, "image.erb"))
unless image_html.include?('<img src="/images/logo.svg" alt="Logo" class="brand" />')
  raise "Image did not render its source, alternative text, and CSS class"
end

columns = Columns.new(css_class: "opening__layout")
columns_html = render_component(columns, File.join(components, "columns.erb"), content: "<div>Left</div>")
unless columns_html.include?('class="two-col opening__layout"') &&
       columns_html.include?("<div>Left</div>")
  raise "Columns did not render its optional CSS class and children"
end

large_code = CodeBlock.new(language: "ruby", framed: false, size: "large")
large_code_html = render_component(
  large_code,
  File.join(components, "code_block.erb"),
  content: "puts :hello"
)
unless large_code_html.include?('class="code-block code-block--unframed code-block--large"') &&
       large_code_html.include?("```ruby")
  raise "CodeBlock did not render its selected size and frame treatment"
end

default_code = CodeBlock.new(size: "unknown")
default_code_html = render_component(default_code, File.join(components, "code_block.erb"))
unless default_code_html.include?('class="code-block code-block--medium"')
  raise "CodeBlock did not fall back to its medium size"
end

disclosures = DisclosureList.new(items: [
  { summary: "Billing", body: "Formatted **details**" }
])
disclosures_html = render_component(disclosures, File.join(components, "disclosure_list.erb"))
unless disclosures_html.include?('<div class="disclosures">') &&
       disclosures_html.include?("<details>") &&
       disclosures_html.include?("<summary>Billing</summary>") &&
       disclosures_html.include?("Formatted **details**")
  raise "DisclosureList did not render its summary and formatted body"
end

contact_form = ContactForm.new(action: "/inquiries", method: "post", variant: "full")
contact_form_html = render_component(contact_form, File.join(components, "contact_form.erb"))
unless contact_form_html.include?('<div class="contact-form-full">') &&
       contact_form_html.include?('<form class="highlight" action="/inquiries" method="post"') &&
       contact_form_html.include?('id="inquiry-company"') &&
       contact_form_html.include?('id="inquiry-timeline"')
  raise "Full ContactForm did not render the complete inquiry form"
end

puts "Validated Actions, CodeBlock, DisclosureList, Grid, Image, Columns, and ContactForm component primitives"
