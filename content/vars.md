---
title: "Context variables"
slug: vars
weight: 60
---


## Context variables

The Mako/Jinja2 templates, whether they are stand-alone or being used to render
markdown (or other) content, receive the following context variables:

- `DATADIR`: The full path to the `data` directory.
- `WEBROOT`: The full path to the `htdocs` directory.
- `CONTENTDIR`: The full path to the `content` directory.
- `TEMPLATES`: A list of all templates which will potentially be rendered
  as stand-alone. Each item in the list contains the keys `src` (relative path
  to the source template), `src_path` (full path to the source template),
  `target` (full path of the file to be written), and `url` (relative url to the
  file to be written).
- `MDCONTENT`: An `MDContentList` representing all the content files which
  will potentially be rendered by a template. Each item in the list contains the
  keys `source_file`, `source_file_short` (truncated and full paths to the
  source), `target` (html file to be written), `template` (filename of the
  template which will be used for rendering), `data` (most of the context
  variables seen by this content), `doc` (the raw content document source), and `url`
  (the `SELF_URL` value for this content – see below). Note that `MDCONTENT` is
  not available inside shortcodes.  An `MDContentList` is a list object with
  some convenience methods for filtering and sorting. It will be described
  further later on.
- Whatever is defined under `template_context` in the `wmk_config.yaml` file
  (see {{< linkto("Configuration file") >}}).
- `SELF_URL`: The relative path to the HTML file which the output of the
  template will be written to.
- `SELF_TEMPLATE`: The path to the current template file (from the template
  root).
- `ASSETS_MAP`: A map of fingerprinted assets (such as javascript or css files),
  used by the `fingerprint` template filter.
- `LOADER`: The template loader/env. In the case of Mako, this is a
  `TemplateLookup` object; in the case of Jinja2 this is an `Environment`
  object with a `FileSystemLoader` loader.
- `site`: A dict-like object containing the variables specified under the `site`
  key in `wmk_config.yaml`.

In the case of Jinja2 templates, three extra context variables are available:

- `mako_lookup`: A Mako `TemplateLookup` instance which makes it possible to call
  Mako templates from a Jinja2 template.
- `get_context`: A function returning all context variables as a dict.
- `import`: An alias for `importlib.import_module` and can thus be used to
  import a Python module into a Jinja template as the value of a variable, e.g.
  `{% set utils = imp0rt('my_utils') %}`. The main intent is to make code inside
  the project `py/` subdirectory as easily available in Jinja templates as it is
  in Mako templates.

When templates are rendering markdown (or other) content, they additionally get
the following context variables:

- `CONTENT`: The rendered HTML produced from the source document.
- `RAW_CONTENT`: The original source document.
- `SELF_FULL_PATH`: The full filesystem path to the source document file.
- `SELF_SHORT_PATH`: The path to the source document file relative to the
  content directory.
- `MTIME`: A datetime object representing the modification time for the source
  file.
- `DATE`: A datetime object representing the first found value of `date`,
  `pubdate`, `modified_date`, `expire_date`, or `created_date` found in the YAML
  front matter, or the `MTIME` value as a fallback. Since this is guaranteed to
  be present, it is natural to use it for sorting and generic display purposes.
- `RENDERER`: A callable which enables a template to render markdown in `wmk`'s
  own environment. This is mainly so that it is possible to support shortcodes
  which depend on other markdown content which itself may contain shortcodes.
  The callable receives a dict containing the keys `doc` (the markdown) and
  `data` (the context variables) and returns rendered HTML.
- `page`: A dict-like object containing the variables defined in the YAML meta
  section at the top of the markdown file, in `index.yaml` files in the markdown
  file directory and its parent directories inside `content`, and possibly in
  YAML files from the `data` directory loaded via the `LOAD` directive in the
  metadata.

For further details on context variables set in the document frontmatter and in
`index.yaml` files, see {{< linkto("Site, page and nav variables") >}}.

