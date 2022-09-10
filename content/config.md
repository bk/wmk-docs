---
title: "Configuration file"
slug: config
weight: 70
---


## Configuration file

A config file, `$basedir/wmk_config.yaml`, can be used to configure some aspects
of how `wmk` operates. The name of the file may be changed by setting the
environment variable `WMK_CONFIG` which should contain a filename without a
leading directory path.

The configuration file **must** exist (but may be empty). Currently there is
support for the following settings:

- `template_context`: Default values for the context passed to Mako templates.
  This should be a dict.

- `site`: Values for common information relating to the website. These are also
  added to the template context under the key `site`. Also
  see {{< linkto("Site and page variables") >}}.

- `render_drafts`: Normally, markdown files with `draft` set to a true value in
  the metadata section will be skipped during rendering. This can be turned off
  (so that the `draft` status flag is ignored) by setting `render_drafts` to True
  in the config file.

- `markdown_extensions`: A list of [extensions][ext] to enable for markdown
  processing by Python-Markdown. The default is `['extra', 'sane_lists']`.
  If you specify [third-party extensions][other] here, you have to install them
  into the Python virtual environment first. Obviously, this has no effect
  if `pandoc` is true. May be set or overridden through frontmatter variables.

- `markdown_extension_configs`: Settings for your markdown extensions. May be
  set in the config file or in the frontmatter. For convenience, there are
  special frontmatter settings for two extensions, namely for `toc` and
  `wikilinks`:
  - The `toc` boolean setting will turn the `toc` extension off if set to False
    and on if set to True, regardless of its presence in `markdown_extensions`.
  - If `toc` is in `markdown_extensions` (or has been turned on via the `toc`
    boolean), then the `toc_depth` frontmatter variable will affect the
    configuration  of the extension regardless of the `markdown_extension_configs`
    setting.
  - If `wikilinks` is in `markdown_extensions` then the options specified
    in the `wikilinks` frontmatter setting will be passed on to the extension.
    Example: `wikilinks: {'base_url': '/somewhere'}`.

- `pandoc`: Normally [Python-Markdown][pymarkdown] is used for Markdown
  processing, but if this boolean setting is true, then Pandoc via
  [Pypandoc][pypandoc] is used by default instead. This can be turned off or on
  through frontmatter variables as well.

- `pandoc_filters`, `pandoc_options`: Lists of filters and options for Pandoc.
  Has no effect unless `pandoc` is true. May be set or overridden through
  frontmatter variables.

- `pandoc_input_format`, `pandoc_output_format`: Which input and output formats
  to assume for Pandoc. The defaults are `markdown` and `html`, respectively.
  For the former the value should be a markdown subvariant, i.e. one of
  `markdown` (pandoc-flavoured), `gfm` (github-flavoured), `markdown_mmd`
  (MultiMarkdown), `markdown_phpextra`, or `markdown_strict`. For the latter,
  it should be an HTML variant, i.e. either `html`, `html5` or `html4`, or
  alternatively one of the HTML-based slide formats, i.e. `s5`, `slideous`,
  `slidy`, `dzslides` or `reavealjs`.  These options have no effect unless
  `pandoc` is true; both may be overridden through frontmatter variables.

- `pandoc_extra_formats`, `pandoc_extra_formats_settings`: If `pandoc` is True,
  then `pandoc_extra_formats` in the frontmatter can be used to convert to
  other formats than HTML, for instance PDF or MS Word (docx).
  `pandoc_extra_formats` is a dict where each key is a format name (e.g.
  `pdf`) and its value is the output filename relative to the web root (e.g.
  `subdir/myfile.pdf`). `pandoc_extra_formats_settings`, if present, contains
  any special settings for the conversion in the form of a dict where each key
  is a format name and its value is either a dict with the keys `extra_args`
  and/or `filters`, or a list (which then is interpreted as the value of
  the `extra_args` setting).

- `use_cache`: boolean, True by default. If you set this to False, the Markdown
  rendering cache will be disabled. This is useful for small and medium-sized
  projects where the final HTML output often depends on factors other than the
  Markdown files themselves. Note that caching for a specific file can be turned
  off by putting `no_cache: true` in the frontmatter.

- `cache_mtime_matters`: boolean, False by default. Normally only the body of
  the markdown file and a few selected processing settings make up the cache
  key. If, on the other hand, this setting is True (either in the configuration
  file or in the frontmatter), then the modification time of the markdown file
  affects the cache key, so touching the file is sufficient for refreshing its
  cache entry.

- `sass_output_style`: The output style for Sass/SCSS rendering. This should be
  one of `compact`, `compressed`, `expanded` or `nested`. The default is
  `expanded`.

- `lunr_index`: If this is True, a search index for `lunr.js` is written as a
  file named `idx.json` in the root of the `htdocs/` directory. Basic
  information about each page (title and summary) is additionally written to
  `idx.summaries.json`.

- `lunr_index_fields`: The default fields for generating the lunr search index
  are `title` and `body`. Additional fields and their weight can be configured
  through this variable. For instance `{"title": 10, "tags": 5, "body": 1}`.
  Aside from `body`, the fields are assumed to be attributes of `page`.

- `lunr_languages`: A two-letter language code or a list of such codes,
  indicating which language(s) to use for stemming when building a Lunr index.
  The default language is `en`. For more on this,
  see {{< linkto("Site search using Lunr") >}}.

- `http`: This is is a dict for configuring the address used for `wmk serve`.
  It may contain either or both of two keys: `port` (default: 7007) and `ip`
  (default: 127.0.0.1). Can also be set directly via command line options.

- `mako_imports`: A list of Python statements to add to the top of each
  generated Mako template module file. Generally these are import statements.

- `theme`: This is the name of a subdirectory to the directory `$basedir/themes`
  (or a symlink placed there) in which to look for extra `static`, `assets`, `py`
  and `template` directories. Note that neither `content` nor `data` directories
  of a theme will be used by `wmk`. A theme-provided template may be rendered as
  stand-alone page, but only if no local template overrides it (i.e. has the
  same relative path). Mako's internal template lookup will similarly first look
  for referenced components in the normal `template` directory before looking in
  the theme directory.

- `extra_template_dirs`: A list of directories in which to look for Mako
  templates. These are placed after both `$basedir/templates` and theme-provided
  templates in the Mako search path. This makes it possible to build up a
  library of Mako components which can be easily used on multiple sites and
  across different themes.

[pymarkdown]: https://python-markdown.github.io/
[pypandoc]: https://github.com/NicklasTegner/pypandoc
[ext]: https://python-markdown.github.io/extensions/
[other]: https://github.com/Python-Markdown/markdown/wiki/Third-Party-Extensions


