---
title: "Shortcodes"
slug: shortcodes
weight: 100
---


## Shortcodes

A shortcode consists of an opening tag, `{{<`, followed by any number of
whitespace characters, followed by a string representing the "short version" of
the content, followed by any number of whitespace characters and the closing tag
`>}}`.

A typical use case is to easily embed content from external sites into your
markdown (or other) content. More advanced possibilities include formatting a
table containing data from a CSV file or generating a cropped and scaled
thumbnail image.

Shortcodes are normally implemented as Mako components named `<shortcode>.mc` in
the `shortcodes` subdirectory of `templates` (or of some other directory in your
template search path, e.g. `themes/<my-theme>/templates/shortcodes`). If
`jinja2_templates` is set to true, however, the shortcode templates are in
Jinja2 format instead, and use the `.jc` extension rather than `.mc`.

The shortcode itself looks like a function call. Note that positional
arguments can only be used if the component has an appropriate `<%page>`
block declaring the expected arguments.

The shortcode component will have access to a context composed of (1) the
parameters directly specified in the shortcode call; (2) the information from
the metadata block of the markdown file in which it appears; (3) a counter
variable, `nth`, indicating number of invocations for that kind of shortcode in
that markdown document; and (4) the global template variables.

Shortcodes are applied **before** the content document is converted to HTML, so
it is possible to replace a shortcode with markdown content which will then be
processed normally. Note, however, that this may lead to undesirable results
when you use such shortcodes in a non-markdown content document.

A consequence of this is that shortcodes do **not** have direct access to (1)
the list of files to be processed, i.e. `MDCONTENT`, or (2) the rendered HTML
(including the parts supplied by the Mako template). A shortcode which needs
either of these must place a (potential) placeholder in the markdown source as
well as a callback in `page.POSTPROCESS`. Each callback in this list will be
called just before the generated HTML is written to `htdocs/` (or, in the case
of a cached page, after document conversion but right before the Mako layout
template is called), receiving the full HTML as a first argument followed by the
rest of the context for the page.  Examples of such shortcodes are `linkto` and
`pagelist`, described below.  (For more on `page.POSTPROCESS` and
`page.PREPROCESS`, see {{< linkto("Site, page and nav variables") >}}).

Here is an example of a simple shortcode call in markdown content:

```markdown
### Yearly expenses

{{< csv_table('expenses_2021.csv') >}}
```

Here is an example `csv_table.mc` Mako component that might handle the above
shortcode call:

```mako
<%page args="csvfile, delimiter=',', caption=None"/>
<%! import os, csv %>
<%
info = []
with open(os.path.join(context.get('DATADIR'), csvfile.strip('/'))) as f:
    info = list(csv.DictReader(f, delimiter=delimiter))
if not info:
    return ''
keys = info[0].keys()
%>
<table class="csv-table">
  % if caption:
    <caption>${ caption }</caption>
  % endif
  <thead>
    <tr>
      % for k in keys:
        <th>${ k }</th>
      % endfor
    </tr>
  </thead>
  <tbody>
    % for row in info:
      <tr>
        % for k in keys:
          <td>${ row[k] }</td>
        % endfor
      </tr>
    % endfor
  </tbody>
</table>
```

Note that if Jinja2 templates are being used, positional arguments are not
supported except for in built-in shortcodes, so the shortcode call in the
Markdown in the above example would have to be changed to
`cvs_table(csvfile='expenses_2021.csv')` or similar.

Shortcodes can take up more than one line if desired, for instance:

```markdown
{{< figure(
      src="/img/2021/11/crocodile-or-alligator.jpg",
      caption="""
Although they appear similar, **crocodiles** and **alligators** differ in easy-to-spot ways:

- crocodiles have narrower and longer heads;
- their snouts are more V-shaped;
- also, crocodiles have a protruding tooth, visible when their mouth is closed.
""") >}}
```

In this example, the caption contains markdown which would be converted to HTML
by the shortcode component (assuming we're dealing with the default `figure`
shortcode).

Note that shortcodes are not escaped inside code blocks, so if you need to show
examples of shortcode usage in your content they must be escaped in some way in
such contexts.  One relatively painless way is to put a non-breaking space
character after the opening tag `{{<` instead of a space.

### Default shortcodes

The following default shortcodes are provided by the `wmk` installation:

- `figure`: An image wrapped in a `<figure>` tag. Accepts the following
  arguments: `src` (the image path or URL), `img_link`, `link_target`,
  `caption`, `figtitle`, `alt`, `credit` (image attribution), `credit_link`,
  `width`, `height`, `resize`.  Except for `src`, all arguments are optional.
  The caption and credit will be treated as markdown. If `resize` is True and
  width and height have been provided, then a resized version of the image is
  used instead of the original via the `resize_image` shortcode (the details can
  be controlled by specifying a dict representing `resize_image` arguments
  rather than a boolean; see below).

- `gist`: A Github gist. Two arguments, both required: `username` and `gist_id`.

- `include`: Insert the contents of the named file at this point.
  One required argument: `filename`. Optional argument: `fallback` (which
  defaults to the empty string), indicating what to show if the file is not
  found. The file must be inside the content directory (`CONTENTDIR`), otherwise
  it will not be read. The path is interpreted as relative to the directory in
  which the content file is placed. A path starting with `/` is taken to start
  at `CONTENTDIR`.  Nested includes are possible but the paths of sub-includes
  are interpreted relative to the original directory (rather than the directory
  in which the included file has been placed). Note that `include()` is always
  handled before other shortcodes.

- `linkto`: Links to the first matching (markdown-based) page. The first
  parameter, `page`, specifies the page which is to be linked to. This is either
  (a) a simple string representing a slug, title, (partial) path/filename or
  (partial) URL; or (b) a `match_expr` in the form of a dict or list which will
  be passed to `page_match()` with a `limit` of 1. Optional arguments: `label`
  (the link text; the default is the title of the matching page); `ordering`,
  passed to `page_match()` if applicable; `fallback`, the text to be shown if
  no matching page is found: `(LINKTO: page not found)` by default; the
  boolean `unique`, which if set to True causes a fatal error to be raised if
  multiple pages are found to match; and `link_attr`, which is a string to
  insert into the `<a>` tag (by default `class="linkto"`). A query string or
  anchor ID fragment for the link can be added via `link_append`, e.g.
  `link_append='#section2'` or `link_append='?q=searchstring'`. If the boolean
  parameter `url_only` is True, then the output will not be a link but only
  the URL (including `link_append`, if any).

- `pagelist`: Runs a `page_match()` and lists the found pages. Required argument:
  `match_expr`. Optional arguments: `exclude_expr`, `ordering`, `limit`,
  `template`, `fallback`, `template_args`, `sql_match`. `exclude_expr` is a
  match expression which serves to *exclude* pages from the list found using the
  `match_expr`.  For instance, `pagelist({'has_tag': True},
  exclude_expr={'has_tag': 'private'})` finds all tagged pages except those that
  have the tag `private`.  The default way of representing the found pages is a
  simple unordered list of links to them, using the page titles as the link
  text. If nothing is found, a string specified in the `fallback` parameter (by
  default an empty string) replaces the shortcode call. The formatting of the
  list can be changed by pointing to a Mako template using the `template`
  argument, which will receive the argument `pagelist` (a `MDContentList` of
  found pages), as well as `template_args`, if any. The template will only be
  called if something is found. If `sql_match` is True, the `match_expr` and
  `ordering` and `limit` will be passed to `page_match_sql()` (as
  `where_clause`, `order_by`, and `limit`, respectively) rather than to
  `page_match()`.

- `resize_image`: Scales and crops images to a specified size. Required
  arguments: `path`, `width`, `height`. Optional arguments: `op` ('fit_width',
  'fit_height', 'fit', 'fill'; the last is the default), `format` ('jpg' or
  'png'; default is 'jpg'), `quality` (default 0.75 and applies only to jpegs),
  `focal_point` (default `center`; only used for `op='fill'`).
  Returns a path under `/resized_images/` (possibly prefixed with the value of
  `site.leading_path`) pointing to the resized version of the image.  The
  filename incorporates a SHA1 hash, so repeated requests for the same
  resize operation are only performed once.  The source `path` is taken to be
  relative to the `WEBROOT`, i.e. the project `htdocs` directory.

- `template`: The first argument (`template`) is either the filename of a
  template or literal template source code. The heuristic used to distinguish
  between these two cases is simply that filenames are assumed never to contain
  whitespace while source code always does. In either case, the template
  is called and its output inserted into the content document. The boolean
  argument `is_jinja` (default False) can be used to indicate that the given
  template source code is to be handled by Jinja2; otherwise Mako is assumed.
  For template files, however, the currently active engine as determined by the
  value of the `jinja2_templates` is always used, regardless of the `is_jinja`
  parameter. Any additional arguments are passed directly on to the template
  (which will also see the normal template context for the shortcode itself).

- `twitter`: A tweet. Takes a `tweet_id`, which may be a Twitter status URL or
  the last part (i.e. the actual ID) of the URL.

- `var`: The value of a variable, e.g. `"page.title"` or `"site.description"`.
  One required argument: `varname`. Optional argument: `default` (which defaults
  to the empty string), indicating what to show if the variable is not available.

- `vimeo`: A Vimeo video. One required argument: `id`. Optional arguments:
  `css_class`, `autoplay`, `dnt` (do not track), `muted`, `title`.

- `youtube`: A YouTube video. One required argument: `id`. Optional arguments:
  `css_class`, `autoplay`, `title`, `nowrap`, `nocookie`, `width`, `height`.

- `wp`: A link to Wikipedia. One required argument: `title`. Optional arguments:
  `label`, `lang`. Example: `{{< wp('L.L. Zamenhof', lang='eo') >}}`.

