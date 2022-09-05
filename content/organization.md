---
title: "File organization"
slug: organization
weight: 40
---


## File organization

Inside a given working directory, `wmk` assumes the following subdirectories for
content and output. They will be created if they do not exist:

- `htdocs`: The output directory. Rendered, processed or copied content is
  placed here, and `wmk serve` will serve files from this directory.

- `templates`: Mako templates. Templates with the extension `.mhtml` are
  rendered directly into `htdocs` as `.html` files (or another extension if the
  filename ends with `.$ext\.mhtml`, where `$ext` is a string consisting of 2-4
  alphanumeric characters), unless their filename starts with a dot or
  underscore or contains the string `base`, or if they are directly inside a
  subdirectory named `base`. For details on context variables received by such
  stand-alone templates, see {{< linkto("Context variables") >}}.

- `content`: Markdown content with YAML metadata. This will be rendered into
  html using the `template` specified in the metadata or `md_base.mhtml` by
  default. The target filename will be `index.html` in a directory corresponding
  to the basename of the markdown file, unless `pretty_path` in the metadata is
  `false` or the name of the Markdown file itself is `index.md` (in which case
  only the extension is replaced). The converted content will be passed to the
  Mako template as a string in the context variable `CONTENT`, along with other
  metadata. A YAML datasource can be specified in the metadata block as `LOAD`;
  the data in this file will be added to the context. For further details on the
  context variables, see {{< linkto("Context variables") >}}. Files that have other
  extensions than `.md` or `.yaml` will be copied directly over to the
  (appropriate subdirectory of the) `htdocs` directory. This is so as to enable
  "bundling", i.e. keeping images together with related markdown files.

- `data`: YAML files for additional metadata.

- `py`: Directory for Python files. This directory is automatically added to the
  front of `sys.path` before Mako is initialized, meaning that Mako templates
  can import modules placed here. Implicit imports are possible by setting
  `mako_imports` in the config file (see {{< linkto("Configuration file") >}}).
  There are also two special files that may be placed here: `wmk_autolaod.py` in
  your project, and `wmk_theme_autoload.py` in the theme's `py/` directory.  If
  one or both of these is present, wmk imports a dict named `autoload` from
  them. This means that you can assign `PREPROCESS` and `POSTPROCESS` page
  actions by name (i.e. keys in the `autoload` dict) rather than as function
  references, which in turn makes it possible to specify them in the frontmatter
  directly rather than having to do it via a shortcode. (For more on `PRE-` and
  `POSTPROCESS`, see {{< linkto("Site and page variables") >}}).

- `assets`: Assets for an asset pipeline. Currently this only handles SCSS/Sass
  files in the subdirectory `scss`. They will be compiled to CSS which is placed
  in the target directory `htdocs/css`.

- `static`: Static files. Everything in here will be rsynced directoy over to
  `htdocs`.

