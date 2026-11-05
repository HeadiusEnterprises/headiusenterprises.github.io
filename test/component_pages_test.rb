require "yaml"

MAIN_PAGES = %w[index services about resources blog contact privacy].freeze
GENERIC_COMPONENTS = %w[Actions CodeBlock DisclosureList Grid MarkdownBlock HTMLBlock Image].freeze
descriptions = Dir[File.expand_path("../src/_components/*.portside.yml", __dir__)]
component_types = descriptions.map { |path| YAML.safe_load_file(path).fetch("type") }

raise "Duplicate component descriptions" unless component_types.uniq.length == component_types.length
missing_generic_components = GENERIC_COMPONENTS - component_types
raise "Missing generic component descriptions: #{missing_generic_components.join(', ')}" unless missing_generic_components.empty?

MAIN_PAGES.each do |page|
  source = File.read(File.expand_path("../src/#{page}.erb", __dir__))
  frontmatter, body = source.split("---", 3).drop(1)
  rendered_types = body.scan(/<%=\s*render\s+(\w+)\.new/).flatten

  raise "#{page} still has the obsolete component opt-in" if frontmatter.include?("portside: components")
  raise "#{page} does not render a component" if rendered_types.empty?

  unknown_types = rendered_types - component_types
  raise "#{page} renders unconfigured components: #{unknown_types.join(', ')}" unless unknown_types.empty?
  raise "#{page} still contains a raw top-level section" if body.match?(/^<section\b/)
end

about_source = File.read(File.expand_path("../src/about.erb", __dir__))
raise "About still uses TeamSection" if about_source.include?("TeamSection")
raise "About still uses ListSection" if about_source.include?("ListSection")
raise "About still uses SplitSection" if about_source.include?("SplitSection")
unless about_source.scan(/render Section\.new/).length >= 5 &&
       about_source.scan(/render Columns\.new/).length >= 3
  raise "About split sections were not composed from Section and Columns"
end
home_source = File.read(File.expand_path("../src/index.erb", __dir__))
%w[HomeHero HomePitch].each do |type|
  raise "Home still uses #{type}" if home_source.include?(type)
end
raise "Home still uses CustomerQuotesSection" if home_source.include?("CustomerQuotesSection")
raise "Home still uses SupportPackagesSection" if home_source.include?("SupportPackagesSection")
unless home_source.include?("render CustomerQuote.new")
  raise "Home does not expose its customer quote rotator"
end
unless home_source.include?("render Grid.new") && home_source.include?("render SupportPlan.new")
  raise "Home support packages were not composed from Grid and SupportPlan"
end
unless home_source.scan(/render SupportPlan\.new/).length == 3 &&
       home_source.include?('variant: "custom"') &&
       home_source.include?('framed: false') &&
       home_source.include?('label: "Headius.contact!"')
  raise "Home custom support option was not composed from Card, CodeBlock, and Actions"
end
support_plan_description = YAML.safe_load_file(
  File.expand_path("../src/_components/support_plan.portside.yml", __dir__)
)
if support_plan_description.fetch("fields").key?("custom")
  raise "SupportPlan still exposes its obsolete custom rendering branch"
end
unless home_source.scan(/render Section\.new/).length >= 4 &&
       home_source.scan(/render Columns\.new/).length >= 3 &&
       home_source.scan(/render Image\.new/).length == 2 &&
       home_source.include?("render HTMLBlock.new")
  raise "Home hero and pitch were not composed from generic components"
end
[about_source, home_source].each do |source|
  raise "Contact still uses HomeContact" if source.include?("HomeContact")
  raise "Contact does not expose its form" unless source.include?("ContactForm")
  raise "Contact details are not a labeled list" unless source.include?("LabeledList")
end

gallery_sources = %w[about resources].map do |page|
  File.read(File.expand_path("../src/#{page}.erb", __dir__))
end
gallery_sources.each do |source|
  raise "Gallery still uses PageVideoGallery" if source.include?("PageVideoGallery")
  raise "Gallery does not expose its video list" unless source.include?("VideoList")
end

resources_source = File.read(File.expand_path("../src/resources.erb", __dir__))
raise "Resources still uses ArticleGrid" if resources_source.include?("ArticleGrid")
raise "Resources still uses CallToActionSection" if resources_source.include?("CallToActionSection")
raise "Resources does not expose its article list" unless resources_source.include?("ArticleList")
raise "Resources still uses ListSection" if resources_source.include?("ListSection")
unless resources_source.scan(/render LabeledList\.new/).length == 4
  raise "Resources does not expose its four labeled lists"
end
unless resources_source.include?("render Actions.new")
  raise "Resources call to action was not composed from Actions"
end

services_source = File.read(File.expand_path("../src/services.erb", __dir__))
%w[ServiceTier FeatureGrid TermsSection].each do |type|
  raise "Services still uses #{type}" if services_source.include?(type)
end
unless services_source.scan(/render Actions\.new/).length == 3 &&
       services_source.include?("render Grid.new") &&
       services_source.include?("render DisclosureList.new")
  raise "Services were not composed from Actions, DisclosureList, and Grid"
end

contact_source = File.read(File.expand_path("../src/contact.erb", __dir__))
raise "Contact still uses ContactPageSection" if contact_source.include?("ContactPageSection")
unless contact_source.include?("render LabeledList.new") &&
       contact_source.include?('variant: "full"')
  raise "Contact details and full form were not composed"
end

privacy_source = File.read(File.expand_path("../src/privacy.erb", __dir__))
raise "Privacy still uses PrivacySection" if privacy_source.include?("PrivacySection")
unless privacy_source.include?("render Section.new") &&
       privacy_source.include?("render Heading.new") &&
       privacy_source.scan(/render MarkdownBlock\.new/).length == 2
  raise "Privacy was not composed from generic components"
end

about_page = File.read(File.expand_path("../output/about/index.html", __dir__))
unless about_page.include?('<span class="k">class</span> <span class="nc">CharlesOliverNutter</span>')
  raise "Composed team code was not highlighted"
end
unless about_page.include?("<p>Three decades of software development")
  raise "MarkdownBlock did not render Markdown"
end
raise "Team code is still framed" unless about_page.include?('code-block code-block--unframed')
raise "Charles's badges lost their container" unless about_page.include?('<p class="badges">')
unless about_page.include?('<strong class="badge badge--crimson">Java Champion</strong>')
  raise "Charles's badge variants were not rendered"
end
unless about_page.include?('<p class="smaller social-links">') &&
       about_page.include?('class="social-link social-link--mastodon" target="_blank" rel="noopener me"')
  raise "Charles's social links lost their presentation or external-link attributes"
end
unless about_page.include?('<svg class="icon" viewBox="0 0 448 512" width="14" height="14" aria-hidden="true">')
  raise "Charles's social links did not render inline icons"
end
raise "Composed conference list was not rendered" unless about_page.include?('<section id="conferences" class="highlight">')
raise "Conference note lost its style" unless about_page.include?('<div class="conf-note"><p>More dates')
unless about_page.include?('<section id="story" class="highlight">') &&
       about_page.include?("Headius::Origin") &&
       about_page.include?('<div class="two-col">')
  raise "Composed story section was not rendered"
end

not_found_page = File.read(File.expand_path("../output/404.html", __dir__))
raise "HTMLBlock escaped trusted HTML" unless not_found_page.include?('<section id="error-page">')

privacy_page = File.read(File.expand_path("../output/privacy/index.html", __dir__))
unless privacy_page.include?('<section id="privacy">') &&
       privacy_page.include?('<p class="updated"><strong>Last updated:</strong> April 2026</p>')
  raise "Composed privacy section lost its structure"
end

home_page = File.read(File.expand_path("../output/index.html", __dir__))
unless home_page.include?('<section id="opening">') &&
       home_page.include?('class="two-col opening__layout"') &&
       home_page.include?('<img src="/images/he-logo.svg" alt="Headius Enterprises" class="opening__logo" />')
  raise "Composed home hero lost its structure"
end
unless home_page.include?('<section id="pitch">') &&
       home_page.include?('<img src="/images/jruby-logo.svg" alt="JRuby" class="pitch__logo" />') &&
       home_page.include?('<div class="card terminal">') &&
       home_page.include?('<span>irb(headius)</span>')
  raise "Composed home pitch lost its structure"
end
unless home_page.include?('<section id="clients">') &&
       home_page.include?('<div class="customer-quote" data-customer-quote data-interval="8000">')
  raise "Composed customer quotes were not rendered"
end

resources_page = File.read(File.expand_path("../output/resources/index.html", __dir__))
raise "Composed article list was not rendered" unless resources_page.include?('<div class="resources-grid">')
raise "Article note lost its style" unless resources_page.include?('<div class="resources-more"><p>Read more')
unless resources_page.include?('<section id="resources-cta" class="highlight">') &&
       resources_page.include?('<div class="actions">') &&
       resources_page.include?('href="/contact" class="button ghost"')
  raise "Composed resource call to action was not rendered"
end

services_page = File.read(File.expand_path("../output/services/index.html", __dir__))
unless services_page.include?('<section id="professional" class="highlight">') &&
       services_page.include?('<div class="card featured">') &&
       services_page.include?('target="_blank" rel="noopener">Expert.subscribe(:yearly)</a>')
  raise "Composed service tiers were not rendered"
end
unless services_page.include?('<div class="component-grid card grid" style="--grid-columns: 2">') &&
       services_page.include?('<span class="nf">email_support</span>')
  raise "Composed feature grid was not rendered"
end
unless services_page.include?('<section id="terms">') &&
       services_page.include?('<div class="disclosures">') &&
       services_page.include?('<summary>Billing &amp; Cancellation</summary>')
  raise "Composed disclosure list was not rendered"
end

contact_page = File.read(File.expand_path("../output/contact/index.html", __dir__))
unless contact_page.include?('<section id="contact-details" class="highlight">') &&
       contact_page.include?('<ul class="list-table">') &&
       contact_page.include?('<div class="contact-form-full">') &&
       contact_page.include?('id="inquiry-company"')
  raise "Composed contact details and full form were not rendered"
end

unless home_page.include?('<section id="packages" class="highlight">') &&
       home_page.include?('<div class="component-grid grid" style="--grid-columns: 3">')
  raise "Composed support package grid was not rendered"
end

puts "Validated #{MAIN_PAGES.length} component pages and #{GENERIC_COMPONENTS.length} generic components"
