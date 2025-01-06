---
title: "Main features"
slug: features
weight: 10
---


## Main features

The following features are present in several static site generators (SSGs); you
might almost call them standard:

- Markdown or HTML content with YAML metadata in the frontmatter.
- Support for themes.
- Sass/SCSS support (via either [`libsass`][libsass] or [Dart Sass][dartsass]).
- Can generate a search index for use by [`lunr.js`][lunr].
- Shortcodes for more expressive and extensible content.

The following features are among the ones that set wmk apart:

- By default, the content is rendered using [Mako][mako], a template system
  which makes all the resources of Python easily available to you. However
  [Jinja2][jinja] templates are also supported if that is what you prefer.
- "Stand-alone" templates – i.e. templates that are not used for presenting
  markdown-based content – are also rendered if present. This can e.g. be used
  for list pages or content based on external sources (such as a database).
- Additional data for the site may be loaded from separate YAML files ­ or even
  (with a small amount of Python/Mako code) from other data sources such as CSV
  files, SQL databases or REST/graphql APIs.
- The shortcode system is quite powerful and flexible. For instance, among the
  default shortcodes are an image thumbnailer and a page list component. A
  shortcode is just a template, so you can easily build your own.
- Optional support for the powerful [Pandoc][pandoc] document converter, for the
  entire site or on a page-by-page basis. This gives you access to such features
  as LaTeX math markup and academic citations, as well as to Pandoc's
  well-designed filter system for extending markdown. Pandoc also enables you to
  export your content to other formats (such as PDF) in addition to HTML, if you
  so wish.
- Also via Pandoc, support for several non-markdown input formats for content,
  namely LaTeX, Org, RST, Textile, Djot, Typst, man, JATS, TEI, Docbook, RTF,
  DOCX, ODT and EPUB.

The only major feature that wmk is missing compared to some other SSGs is tight
integration with a Javascript assets pipeline and interaction layer. Although
wmk allows you to configure virtually any assets processing you like, this
nevertheless means that if your site is reliant upon React, Vue or similar, then
other options are probably more convenient.

That exception aside, wmk is suitable for building any small or medium-sized
static website (up to a couple of thousand pages, depending on the content).

[libsass]: https://sass.github.io/libsass-python/
[dartsass]: https://sass-lang.com/dart-sass/
[lunr]: https://lunrjs.com/
[mako]: https://www.makotemplates.org/
[jinja]: https://jinja.palletsprojects.com/
[pandoc]: https://pandoc.org/

