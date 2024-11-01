---
title: "Template filters"
slug: template_filters
weight: 120
---


## Template filters

In addition to the built-in template filters provided by
[Mako]((https://docs.makotemplates.org/en/latest/filtering.html)) or
[Jinja2](https://jinja.palletsprojects.com/en/stable/templates/#list-of-builtin-filters)
respectively, the following filters are by default made available in templates:

- `date`: date formatting using strftime. By default, the format '%c' is used.
  A different format is specified using the `fmt` parameter, e.g.:
  `${ page.pubdate | date(fmt=site.date_format) }`.

- `date_to_iso`: Format a datetime as ISO 8601 (or similarly, depending on
  parameters). The parameters are `sep` (the separator between the date part and
  the time part; by default 'T', but a space is sensible as well); `upto` (by
  default 'sec', but 'day',  'hour' and 'frac' are also acceptable values); and
  `with_tz` (by default False).

- `date_to_rfc822`: Format a datetime as RFC 822 (a common datetime format in
  email headers and some types of XML documents).

- `date_short`: E.g. "7 Nov 2022".

- `date_short_us`: E.g. "Nov 7th, 2022".

- `date_long`: E.g. "7 November 2022".

- `date_long_us`: E.g. "November 7th, 2022".

- `slugify`: Turns a string into a slug. Only works for strings in the Latin
  alphabet.

- `markdownify`: Convert markdown to HTML. It is possible to specify custom
  extensions using the `extensions` argument.

- `truncate`: Convert markdown/html to plaintext and return the first `length`
  characters (default: 200), with an `ellipsis` (default: "…") appended if any
  shortening has taken place.

- `truncate_words`: Convert markdown/html to plaintext and return the first
  `length` words (default: 25), with an `ellipsis` (default "…") appended if any
  shortening has taken place.

- `p_unwrap`: Remove a wrapping `<p>` tag if and only if there is only one
  paragraph of text. Suitable for short pieces of text to which a markdownify
  filter has previously been applied. Example: `<h1>${ page.title |
  markdownify,p_unwrap }</h1>`.

- `strip_html`: Remove any markdown/html markup from the text. Paragraphs will
  not be preserved.

- `cleanurl`: Remove trailing 'index.html' from URLs.

- `url`: Unless the given path already starts with '/', '.' or 'http',
  prefix it with the first defined leading path of `site.leading_path`,
  `site.base_url` or a literal `/`. Postfix a `/` unless the path already has
  one or seems to end with a file extension. Calls `cleanurl` on the result.

- `to_json`: converts the given data structure to JSON. Note that this should
  not normally be used as a string filter (i.e. `${ value | to_json }`)
  but directly as a function, like this: `${ to_json(value) }`.

- `fingerprint`: Replace an unadorned path to an assets file with its
  fingerprinted (i.e. versioned) equivalent. Example: `${ 'js/site.js' | url, fingerprint }`.
  Uses the corresponding entry from the `ASSETS_MAP` context variable if it is
  available but otherwise proceeds to do the fingerprinting itself.

If you wish to provide additional filters in Mako without having to explicitly
define or import them in templates, the best way of doing this his to add them
via the `mako_imports` setting in `wmk_config.yaml` (see above). There is
currently no easy way to do this if Jinja2 templates are being used, however.

Please note that in order to avoid conflicts with the above filters you should
not place a file named `wmk_mako_filters.py` or `wmk_jinja2_extras.py` in your
`py/` directories.

