# Development

This is a Bridgetown site whose editable pages are composed from components. Portside reads the component descriptions in `src/_components/*.portside.yml`, but Bridgetown and the site-owned components remain responsible for presentation.

## Running the site

Install the Ruby and Node dependencies, then start Bridgetown:

```sh
bundle install
npm install
bin/bridgetown start
```

For a production-style verification, build the frontend first so Bridgetown writes the current hashed asset names into the generated pages:

```sh
npm run esbuild
bundle exec rake test
```

## Social links in Markdown

Kramdown supports inline attribute lists, which let ordinary Markdown carry the small amount of metadata needed for the social-link presentation:

```markdown
[@headius](https://mastodon.social/@headius){:.social-link .social-link--mastodon target="_blank" rel="noopener me"} · [@headius](https://bsky.app/profile/headius.bsky.social){:.social-link .social-link--bluesky target="_blank" rel="noopener"} · [@headius](https://x.com/Headius){:.social-link .social-link--x target="_blank" rel="noopener"}
{: .smaller .social-links}
```

The block attribute list adds `smaller` and `social-links` to the paragraph. Each inline attribute list adds the external-link attributes and a platform marker to its link.

`plugins/social_link_icons.rb` extends Kramdown's HTML converter. When it sees one of the known platform classes, it inserts the corresponding inline SVG at the start of the link. Inline SVG is intentional here: it inherits the link's `currentColor` and renders the same way as the original hand-written markup. External CSS masks looked equivalent on paper, but produced visible artefacts at this size.

The recognised classes are:

- `social-link--mastodon`
- `social-link--bluesky`
- `social-link--x`

To add another platform, add its view box and path to `SocialLinkIcons::ICONS`, use the matching class in the Markdown link, and add a rendered-output assertion to `test/component_pages_test.rb`. The converter ignores ordinary links and links whose classes it does not recognise.

Portside preserves this syntax as Markdown through a parse/serialise round trip. The extension belongs to the site rather than Portside because the classes, icons, and resulting markup are all presentation choices.
