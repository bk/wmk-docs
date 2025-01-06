---
title: "Configuration file"
slug: config
weight: 70
---


## Configuration file

A config file, `$basedir/wmk_config.yaml`, can be used to configure many aspects
of how `wmk` operates. The name of the file may be changed by setting the
environment variable `WMK_CONFIG` which should contain a filename without a
leading directory path.

The configuration file **must** exist (but may be empty). If it specifies a theme
and a file named `wmk_config.yaml` (*regardless* of the `WMK_CONFIG` environment
variable setting) exists in the theme directory, then any settings in that file
will be merged with the main config – unless `ignore_theme_conf` is true.

It is also possible to split the configuration file up into several smaller
files. These are placed in the `wmk_config.d/` directory (inside the base
directory). The filename of each yaml file in that directory (minus the `.yaml`
extension) is treated as a key and the contents as its value. Subdirectories can
be used to represent a nested structure. For instance, the file
`wmk_config.d/site/colors/darkmode.yaml` would contain the settings that
will be visible to templates as the `site.colors.darkmode` variable.
Note that the `WMK_CONFIG` environment variable affects the name of the
directory looked for; setting it to `myconf.yaml` would e.g.  mean that `wmk`
will inspect `myconf.d/` for extra configuration settings instead of
`wmk_config.d/` (although this does not apply to themes, whose configuration
file/directory name is fixed).

Currently there is support for the following settings:

- `template_context`: Default values for the context passed to templates.
  This should be a dict.

- `site`: Values for common information relating to the website. These are also
  added to the template context under the key `site`. They are often used by
  templates and themes to affect the look and feel of the website. For further
  discussion, see {{< linkto("Site, page and nav variables") >}}.

- `render_drafts`: Normally, content files with `draft` set to a true value in
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

- `pandoc`: Normally [Python-Markdown][pymarkdown] is used for markdown
  processing, but if this boolean setting is true, then Pandoc via
  [Pypandoc][pypandoc] is used by default instead. This can be turned off or on
  through frontmatter variables as well. Another config setting which affects
  whether Pandoc is used is `content_extensions`, for which see below.

- `pandoc_filters`, `pandoc_options`: Lists of filters and options for Pandoc.
  Has no effect unless `pandoc` is true. May be set or overridden through
  frontmatter variables.

- `pandoc_input_format`: Which input format to assume for Pandoc; has no effect
  unless `pandoc` is true. The default value is `markdown`.  If set, the value
  should be a markdown subvariant for markdown-like content, i.e. one of
  `markdown` (pandoc-flavoured), `gfm` (github-flavoured), `markdown_mmd`
  (MultiMarkdown), `markdown_phpextra`, `markdown_strict`, `commonmark`, or
  `commonmark_x`. As for other supported input formats, there is little reason
  to set `pandoc_input_format` explicitly for them, since they have no variants
  in the relevant sense, and the right format is picked based on the file
  extension. May be set or overridden through frontmatter variables.

- `pandoc_output_format`: Output format for Pandoc; has no effect unless
  `pandoc` is true. This should be a HTML variant, i.e. either `html`, `html5`
  or `html4`, or alternatively one of the HTML-based slide formats, i.e.  `s5`,
  `slideous`, `slidy`, `dzslides` or `reavealjs`. Chunked HTML (new in Pandoc 3)
  is not supported. May be set or overridden through frontmatter variables.

- `pandoc_extra_formats`, `pandoc_extra_formats_settings`: If `pandoc` is True,
  then `pandoc_extra_formats` in the frontmatter can be used to convert to
  other formats than HTML, for instance PDF or MS Word (docx).
  `pandoc_extra_formats` is a dict where each key is a format name (e.g.
  `pdf`) and its value is the output filename relative to the web root (e.g.
  `subdir/myfile.pdf`). The special value `auto` indicates that the name of the
  output file should be based on that of the source file but with the file
  extension replaced by the name of the format. For instance, a source file
  named `subdir/index.md` (relative to the content directory) maps to an output
  file named `subdir/index.pdf` (relative to the web root directory) if the
  output format is `pdf`, and so on. `pandoc_extra_formats_settings`, if
  present, contains any special settings for the conversion in the form of a
  dict where each key is a format name and its value is either a dict with the
  keys `extra_args` and/or `filters`, or a list (which then is interpreted as
  the value of the `extra_args` setting).

- `slugify_dirs`: Affects the names of directories created in `htdocs` because
  of the `pretty_path` setting. If `true` (which is the default), the name will
  be identical to the `slug` of the source file. If explicitly set to `false`,
  then the directory name will be the same as the basename of the source file,
  almost regardless of the characters in the filename.

- `use_cache`: boolean, True by default. If you set this to False, the
  rendering cache will be disabled. This is useful for small and medium-sized
  projects where the final HTML output often depends on factors other than the
  content file alone. Note that caching for a specific file can be turned
  off by putting `no_cache: true` in the frontmatter.

- `cache_mtime_matters`: boolean, False by default. Normally only the body of
  the markdown file and a few selected processing settings make up the cache
  key. If, on the other hand, this setting is True (either in the configuration
  file or in the frontmatter), then the modification time of the markdown file
  affects the cache key, so touching the file is sufficient for refreshing its
  cache entry.

- `use_sass`: A boolean indicating whether to handle Sass/SCSS files in `assets/scss`
  automatically. True by default.

- `use_dart_sass`: By default, Sass/SCSS is handled by libsass. If
  `use_dart_sass` is true, Dart Sass is used instead. This requires it to be
  installed as an external command.

- `dart_sass_bin`: This can be set to point to the location of the `sass`
  executable that will be run when `use_dart_sass` is true. Normally not needed
  unless `sass` is not in your `PATH` or you want to add parameters (or use a
  specific version).

- `sass_output_style`: The output style for Sass/SCSS rendering. This should be
  one of `compact`, `compressed`, `expanded` or `nested`. The default is
  `expanded`. Has no effect if `use_sass` is false. When using Dart Sass,
  `compact` and `nested` have the same effect as `expanded`.

- `assets_map`: An assets map is a mapping from filenames or aliases to names
  of files containing a hash identifier (under the webroot). A typical entry
  might thus map from `/css/style.css` to `/css/style.1234abcdef56.css`. The
  value of this setting is either a dict or the name of a JSON or YAML file
  (inside the data directory) containing the mapping. It will be available to
  templates as `ASSETS_MAP`.

- `assets_fingerprinting`: A boolean indicating whether to automatically
  fingerprint assets files (i.e. add hash indicators to their names). If true,
  any fingerprinted files will be added to the `ASSETS_MAP` template variable.

- `assets_fingerprinting_conf`: A dict where the keys are subdirectories of the
  webroot, e.g. `js` or `img/icons`, and the values are dicts containing the
  keys `pattern` and (optionally) `exclude`. These are regular expressions
  indicating which files to fingerprint under these directories. The filename is
  fingerprinted if it matches `pattern` but does not match `exclude`. (The
  default value of `exclude` looks for files that appear to have been
  fingerprinted already and thus does not normally need to be set). The default
  value of this setting is a simple setup for the `js` and `css` subdirectories
  of the webroot.

- `assets_commands`: A list of arbitrary commands to run at the assets
  compilation stage (just before Sass/SCSS files in `assets/scss` are processed,
  assuming `use_sass` is not false). The commands are run in order inside the
  base directory of the site. Example: `['bin/fetch_external_assets.sh', 'node
  esbuild.mjs']`.

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
  see {{< linkto("Site search") >}}.

- `http`: This is is a dict for configuring the address used for `wmk serve`.
  It may contain either or both of two keys: `port` (default: 7007) and `ip`
  (default: 127.0.0.1). Can also be set directly via command line options.

- `output_directory`: Normally the output will be written to the directory
  `htdocs` inside the basedir, but this can be overridden by setting this
  configuration variable. The value should be a relative path that does not
  start with `/` or `.`, e.g. `site` or `public`.

- `mako_imports`: A list of Python statements to add to the top of each
  generated Mako template module file. Generally these are import statements.

- `theme`: This is the name of a subdirectory to the directory `$basedir/themes`
  (or a symlink placed there) in which to look for extra `static`, `assets`, `py`
  and `template` directories. Note that neither `content` nor `data` directories
  of a theme will be used by `wmk`. A theme-provided template may be rendered as
  stand-alone page, but only if no local template overrides it (i.e. has the
  same relative path). Mako's internal template lookup will similarly first look
  for referenced components in the normal `template` directory before looking in
  the theme directory. Configuration settings from `wmk_config.yaml` in the
  theme directory will be used as long as they do not conflict with those
  in the main config file.

- `ignore_theme_conf`: If set to true in the main configuration file, this tells
  wmk to ignore any settings in `wmk_config.yaml` in the theme directory.

- `extra_template_dirs`: A list of directories in which to look for template
  files. These are placed after both `$basedir/templates` and theme-provided
  templates in the template engine search path. This makes it possible to build
  up a library of components which can be easily used on multiple sites and
  across different themes.

- `jinja2_templates`: If this boolean setting is true, it indicates that the
  template files in the `template` directory (and supplied by the theme, or
  otherwise in the template engine search path) are to be interpreted by Jinja2
  rather than Mako. Note that Jinja2 templates used standalone or as layout
  templates for Markdown content should have the extension `.html` rather than
  `.mhtml`.

- `redirects`: If this is True or a string pointing to a YAML file in the
  `data/` directory (whose default name is `redirects.yaml`), then wmk will
  write HTML stubs containing `<meta http-equiv="refresh" ...>` in the indicated
  locations. The contents of the YAML file is a list of entries with the keys
  `from` and `to`. The former is a path under `htdocs/` or a list of such paths,
  while `to` is an absolute or relative URL which you are to be redirected to.

- `content_extensions`: Customize which file extensions are handled inside the
  `content/` directory. May be a list (e.g. `['.md', '.html']`) or a dict. The
  value for each key in the dict should itself be a dict where the following keys
  have an effect: `pandoc` (boolean), `pandoc_input_format` (string), `is_binary`
  (boolean), `raw` (boolean), `pandoc_binary_format` (string). See the value
  of `DEFAULT_CONTENT_EXTENSIONS` in `wmk.py` for details.

- `mdcontent_json`: This option may specify the name of a JSON file to which
  to write the entire `MDCONTENT` object in serialized form, along with the
  environment variables for each page. The destination file may be either in
  `htdocs/`, `data/` or `tmp/`. If the file path does not start with one of
  these, `data` is assumed. The specified (or implied) directory must exist.

- `init_commands`: A list of arbitrary commands to run at the very beginning
  of processing, just after theme settings have been loaded and the Python
  search path configured. They are run in order inside the base directory
  of the site.

- `cleanup_commands`: A list of arbitrary commands to run at the very end of wmk
  processing. The commands are run in order inside the base directory of the
  site.

[pymarkdown]: https://python-markdown.github.io/
[pypandoc]: https://github.com/NicklasTegner/pypandoc
[ext]: https://python-markdown.github.io/extensions/
[other]: https://github.com/Python-Markdown/markdown/wiki/Third-Party-Extensions


