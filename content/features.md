---
title: "Main features"
slug: features
weight: 10
---


## Main features

The following features are present in several static site generators (SSGs); you
might almost call them standard:

- Markdown content with YAML metadata in the frontmatter.
- Support for themes.
- Sass/SCSS support (via [`libsass`][libsass]).
- Can generate a search index for use by [`lunr.js`][lunr].
- Shortcodes for more expressive and extensible Markdown content.

The following features are among the ones that set wmk apart:

- The content is rendered using [Mako][mako], a template system which makes all
  the resources of Python easily available to you.
- "Stand-alone" templates – i.e. templates that are not used for presenting
  Markdown-based content – are also rendered if present.
- Additional data for the site may be loaded from separate YAML files ­ or even
  (with a small amount of Python/Mako code) from other data sources such as CSV
  files, SQL databases or REST/graphql APIs.
- The shortcode system is considerably more powerful than that of most static
  site generators. For instance, among the default shortcodes are an image
  thumbnailer and a page list component. A shortcode is just a Mako component,
  so if you know some Python you can easily build your own.
- Optional support for the powerful [Pandoc][pandoc] document converter, for the
  entire site or on a page-by-page basis. This gives you access to such features
  as LaTeX math markup and academic citations, as well as to Pandoc's
  well-designed filter system for extending Markdown.

The only major feature that wmk is missing compared to some other SSGs is tight
integration with a Javascript assets pipeline and interaction layer. Thus, if
your site is reliant upon React, Vue or similar, then wmk is probably not the
best way to go.

That exception aside, wmk is suitable for building any small or medium-sized
static website (up to a few hundred pages).

[libsass]: https://sass.github.io/libsass-python/
[lunr]: https://lunrjs.com/
[mako]: https://www.makotemplates.org/
[pandoc]: https://pandoc.org/

