---
title: "Site and page variables"
slug: pagevars
weight: 110
---


## Site and page variables

When a markdown file (or other supported content) is rendered, the Mako template
receives a number of context variables as partly described above. A few of these
variables, such as `MDTEMPLATES` and `DATADIR` set directly by `wmk` (see
above). Others are user-configured either (1) in `wmk_config.yaml` (the contents
of the `site` object and potentially additional "global" varaibles in
`template_context`); or (2) the cascade of `index.yaml` files in the `content`
directory and its subdirectories along with the YAML frontmatter of the markdown
file itself, the result of which is placed in the `page` object.

When gathering the content of the `page` variable, `wmk` will
start by looking for `index.yaml` files in each parent directory of the markdown
file in question, starting at the root of the `content` directory and moving
upwards, at each step extending and potentially overriding the data gathered at
previous stages. Only then will the YAML in the frontmatter of the file itself
be parsed and added to the `page` data.

The file-specific frontmatter may be in the content file itself, or it may be in
a separate YAML file with the same name as the content file but with an extra
`.yaml` extension. For instance, if the content filename is `important.md`, then
the YAML file would be named `important.md.yaml`. If both in-file and external
frontmatter is present, the two will be merged, with the in-file values
"winning" in case of conflict.

At any point, a data source in this cascade may specify an extra YAML file using
the special `LOAD` variable. This file will then be loaded as well and
subsequently treated as if the data in it had been specified directly at the
start of the file containing the `LOAD` directive.

Which variables are defined and used by templates is very much up the user,
although a few of them have a predefined meaning to `wmk` itself. For making it
easier to switch between different themes it is however suggested to stick to
the following meaning of some of the variables:

The variables `site` and `page` are dicts with a thin convenience layer on top
which makes it possible to reference subkeys belonging to them in templates
using dot notation rather than subscripts. For instance, if `page` has a dict
variable named `foo`, then a template could contain a fragment such as
`${ page.foo.bar or 'splat' }` -- even if the `foo` dict does not contain a key
named `bar`. Without this syntactic sugar you would have to write something much
more defensive and long-winded such as  `${ page.foo.bar if page.foo and 'bar'
in page.foo else 'splat' }`.

### System variables

The following frontmatter variables affect the operation of `wmk` itself, rather
than being exclusively handled by Mako templates.

#### Templates

**Note** that a variable called something like `page.foo` below is referenced as
such in Mako templates but specified in YAML frontmatter simply as `foo:
somevalue`.

- `page.template` specifies the Mako template which will render the content.

- `page.layout` is used by several other static site generators. For
  compatibility with them, this variable is supported as a fallback synonym with
  `template`.  It has no effect unless `template` has not been specified
  explicitly anywhere in the cascade of frontmatter data sources.

For both `template` and `layout`, the `.mhtml` extension of the template may be
omitted. If the `template` value appears to have no extension, `.mhtml` is
assumed; but if the intended template file has a different extension, then it
of course cannot be omitted.

Likewise, a leading `base/` directory may be omitted when specifying `template`
or `layout`. For instance, a `layout` value of `post` would find the template
file `base/post.mhtml` unless a `post.mhtml` file exists in the template root
somewhere in the template search path.

If neither `template` nor `layout` has been specified and no `default_template`
setting is found in `wmk_config.yaml`, the default template name for markdown
files is `md_base.mhtml`.

#### Affects rendering

- `page.slug`: If the value of `slug` is nonempty and consists exclusively of
  lowercase alphanumeric characters, underscores and hyphens (i.e. matches the
  regular expression `^[a-z0-9_-]+$`), then this will be used instead of the
  basename of the markdown file to determine where to write the output.
  If a `slug` variable is missing, one will be automatically added by `wmk`
  based on the basename of the current markdown file. Templates should therefore
  be able to depend upon slugs always being present. Note that slugs are not
  guaranteed to be unique, although that is good practice.

- `page.pretty_path`: If this is true, the basename of the markdown filename (or the
  slug) will become a directory name and the HTML output will be written to
  `index.html` inside that directory. By default it is false for files named
  `index.md` or `index.html` and true for all other files. If the filename
  contains symbols that do not match the character class `[\w.,=-]`, then it
  will be "slugified" before final processing (although this only works for
  languages using the Latin alphabet).

- `page.do_not_render`: Tells `wmk` not to write the output of this template to
  a file in `htdocs`. All other processing will be done, so the gathered
  information can be used by templates for various purposes. (This is similar to
  the `headless` setting in Hugo).

- `page.draft`: If this is true, it prevents further processing of the markdown
  file unless `render_drafts` has been set to true in the config file.

- `page.no_cache`: If this is true, the rendering cache will not be used for
  this file. (See also the `use_cache` setting in the configuration file).

- `page.markdown_extensions`, `page.markdown_extension_configs`, `page.pandoc`,
  `page.pandoc_filters`, `page.pandoc_options`, `page.pandoc_input_format`,
  `page.pandoc_output_format`: See the description of these options in the
  section on the configuration file, above.

- `page.POSTPROCESS`: This contains a list of processing instructions which are
  called on the rendered HTML just before writing it to the output directory.
  Each instruction is either a function (placed into `POSTPROCESS` by a
  shortcode) or a string (possibly specified in the frontmatter). If the latter,
  it points to a function entry in the `autoload` dict imported from either the
  project's `py/wmk_autoload.py` file or the theme's `py/wmk_theme_autoload.py`
  file.  In either case, the function receives the html as the first argument
  while the rest of the arguments constitute the template context. It should
  return the processed html.

- `page.PREPROCESS`: This is analogous to `page.POSTPROCESS`, except that the
  instructions in the list are applied to the markdown (or other content
  document) just before converting it to HTML. The function receives two
  arguments: the document text and the `page` object. It should return the
  altered document.

Note that if two files in the same directory have the same slug, they may both
be rendered to the same output file; it is unpredictable which of them will go
last (and thus "win the race"). The same kind of conflict may arise between a
slug and a filename or even between two filenames containing non-ascii
characters. It is up to the content author to take care to avoid this; `wmk`
does nothing to prevent it.

### Standard variables and their recommended meaning

The following variables are not used directly by `wmk` but affect templates in
different ways. It is a list of recommendations rather than something which
must be necessarily followed.

#### Typical site variables

Site variables are the keys-value pairs under `site:` in `wmk_config.yaml`.

- `site.title`: Name or title of the site.

- `site.lang`: Language code, e.g. 'en' or 'en-us'.

- `site.tagline`: Subtitle or slogan.

- `site.description`: Site description.

- `site.author`: Main author/proprietor of the site. Depending on the site
  templates (or the theme), may be a string or a dict with keys such as "name",
  "email", etc.

- `site.base_url`: The protocol and hostname of the site (perhaps followed by a
  directory path if `site.leading_path` is not being used). Normally without a
  trailing slash.

- `site.leading_path`: If the web pages built by `wmk` are not at the root of
  the website but in a subdirectory, this is the appropriate prefix path.
  Normally without a trailing slash.

- `site.build_time`: This is automatically added to the site variable by `wmk`.
  It is a datetime object indicating when the rendering phase of the current
  run started.

Templates or themes may be configurable through various site variables, e.g.
`site.paginate` for number of items per page in listings or `site.mainfont` for
configuring the font family.

#### Classic meta tags

These variables mostly relate to the text content and affect the metadata
section of the `<head>` of the HTML page.

- `page.title`: The title of the page, typically placed in the `<title>` tag in the
  `<head>` and used as a heading on the page. Normally the title should not be
  repeated as a header in the body of the markdown file. Most markdown documents
  should have a title. If it is not explicitly specified, the title will be
  generated automatically from the filename.

- `page.slug`: See above. If it is missing, the slug is created from the
  title.

- `page.id`: This is guaranteed to be unique at rendering time. If it is present
  but not unique, then "-1", "-2", etc., will be appended as necessary. If it is
  not explicitly specified, then it is generated by slugifying the full path to
  the source markdown file (relative to the content directory). For instance,
  `blog/2022/09/The letter Þ in Old English.md` will become the ID
  `blog-2022-09-the-letter-th-in-old-english`.

- `page.description`: Affects the `<meta name="description" ...>` tag in the `<head>`
  of the page. The variable `summary` (see later) may also be used as fallback
  here.

- `page.keywords`: Affects the `<meta name="keywords" ...>` tag in the `<head>`
  of the page. This may be either a list or a string (where items are separated
  with commas).

- `page.robots`: Instructions for Google and other search engines relating to
  this content (e.g. `noindex, nofollow`) should be placed in this variable.

- `page.author`: The name of the author (if there is only one). May lead to `<meta
  name="keywords" ...>` tag in the `<head>` as well as appear in the body of the
  rendered HTML file. Some themes may expect this to be a dict with keys such
  as `name`, `email`, `image`, etc.

- `page.authors`: If there are many authors they may be specified here as a list.
  It is up to the template how to handle it if both `author` and `authors` are
  specified, but one way is to add the `author` to the `authors` unless already
  present in the list.

- `page.summary`: This may affect the `<meta name="description" ...>` tag as a
  fallback if no `description` is provided, but its main purpose is for list
  pages with article teasers and similar content.

Note that this is by no means an exhaustive list of variables likely to affect
the `<head>` of the page. Notably, several other variables may affect meta tags
used for sharing on social media. The most common is probably `page.image`
(described below). In any case, the implementation itself is up to the theme or
template author.

#### Dates

Dates and datetimes should normally be in a format conformant with or similar to
ISO 8601, e.g. `2021-09-19` and `2021-09-19T09:19:21+00:00`. The `T` may be
replaced with a space and the time zone may be omitted (localtime is assumed).
If the datetime string contains hours it should also contain minutes, but
seconds may be omitted. If these rules are followed, the following variables
are converted to date or datetime objects (depending on the length of the
string) before they are passed on to templates.

- `page.date`: A generic date or datetime associated with the document.

- `page.pubdate`: The date/datetime when first published. Currently `wmk` does not
  skip files with `pubdate` in the future, but it may do so in a later version.

- `page.modified_date`: The last-modified date/datetime. Note that `wmk` will also
  add the variable `MTIME`, which is the modification time of the file
  containing the markdown source, so this information can be inferred from
  that if this variable is not explicitly specified.

- `page.created_date`: The date the document was first created.

- `page.expire_date`: The date from which the document should no longer be published.
  Similarly to `pubdate`, this currently has no direct effect on `wmk` but may
  do so in a later version.

See also the description of the `DATE` and `MTIME` context variables above.

#### Media content

- `page.image`: The main image associated with the document. Affects the `og:image`
  meta tag in HTML output and may be used for both teasers and content rendering.

- `page.images`: A list of images associated with the document. If `image` is not
  specified, the main image will be taken to be the first in the list.

- `page.audio`: A list of audio files/urls associated with this document.

- `page.videos`: A list of video files/urls associated with this document.

- `page.attachments`: A list of attachments (e.g. PDF files) associated with this
  document.

#### Taxonomy

- `page.section`: One of a quite small number of sections on the site, often
  corresponding to the leading subdirectory in `content`. E.g.  "blog", "docs",
  "products".

- `page.categories`: A list of broad categories the page belongs to. E.g. "Art",
  "Science", "Food". The first-named category may be regarded as the primary
  one.

- `page.tags`: A list of tags relevant to the content of the page. E.g. "quantum
  physics", "knitting", "Italian food".

- `page.weight`: A measure of importance attached to a page and used as an ordering
  key for a list of pages. This should be a positive integer. The list is
  normally ascending, i.e. with the lower numbers at the top. (Pages may of
  course be ordered by other criteria, e.g. by `pubdate`).

