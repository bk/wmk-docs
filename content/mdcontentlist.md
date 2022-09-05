---
title: "Working with lists of pages"
slug: mdcontentlist
weight: 130
---


## Working with lists of pages

Templates which render a list of content files (e.g. a list of blog posts or
pages belonging to a category) will need to filter or sort `MDCONTENT`
accordingly. In order to make this easier, `MDCONTENT` is wrapped in a list-like
object called `MDContentList`, which has the following methods:

### General searching/filtering

Each of the following methods returns a new `MDContentList` containing those
entries for which the predicate (`pred`) is True.

- `match_entry(self, pred)`: The `pred` (i.e. predicate) is a callable which
  receives the full information on each entry in the `MDContentList` and returns
  True or False. 

- `match_ctx(self, pred)`: The `pred` receives the context for each entry and
  returns a boolean.

- `match_page(self, pred)`: The `pred` receives the `page` object for each entry
  and returns a boolean.

- `match_doc(self, pred)`: The `pred` receives the markdown body for each entry
  and returns a boolean.

- `url_match(self, url_pred)`: The `pred` receives the `url` (relative to
  `htdocs`) for each entry and returns a boolean.

- `path_match(self, src_pred)`: The `pred` receives the path to the Markdown
  source for each entry and returns a boolean.

### Specialized searching/filtering

All of these return a new `MDContentList` object.

- `posts(self, ordered=True)`: Returns a new `MDContentList` with those entries
  which are blog posts. In practice this means those with markdown sources in
  the `posts/` or `blog/` subdirectories or those which have a `page.type` of
  "post", "blog", "blog-entry" or "blog_entry". Normally ordered by date (newest
  first), but this can be turned off by setting `ordered` to False.

- `in_date_range(self, start, end, date_key='DATE')`: Posts/pages with a date
  between `start` and `end`. The key for the date field can be specifed using
  `date_key`.  Unless the value for `date_key` is either `DATE` or `MTIME`, then
  the key is looked for in the `page` variables for the entry.

- `has_taxonomy(self, haystack_keys, needles)`: A general search for entries
  belonging to a taxonomy group, such as category, tag, section or type. They
  `haystack_keys` are the `page` variables to examine while `needles` is a list
  of the values to look for in the values of those variables. A string value for
  `needles` is treated as a one-item list. The search is case-insensitive.

- `in_category(self, catlist)`: A shortcut method for
  `self.has_taxonomy(['category', 'categories'], catlist)`

- `has_tag(self, taglist)`: A shortcut method for `self.has_taxonomy(['tag',
  'tags'], taglist)`.

- `in_section(self, sectionlist)`: A shortcut method for
  `self.has_taxonomy(['section', 'sections'], sectionlist)`.

- `page_match(self, match_expr, ordering=None, limit=None)`: This is actually
  quite a general matching method but does not require the caller to pass a
  predicate callable to it, which means that it can be employed in more varied
  contexts than the general methods described in the last section. A
  `match_expr` contains the filtering specification. It will be described
  further below. The `ordering` parameter, if specified, should be either
  `title`, `slug`, `url` or `date`, with an optional `-` in front to indicate
  reverse ordering. The `date` option for `ordering` may be followed by the
  preferred frontmatter date field after a colon, e.g.
  `ordering='-date:modified_date'` for a list with the most recently changed
  files at the top. The `limit`, if specified, obviously indicates the maximum
  number of pages to return.

A `match_expr` for `page_match()` is either a dict or a list of dicts.  If it is
a dict, each page in the result set must match each of the attributes specified
in it. If it is a list of dicts, each page in the result set must match at least
one of the dicts (i.e., the returned result set contains the union of all
matches from all dicts in the list). When a string or regular expression match
is being performed in this process, it will be case-insensitive. The supported
attributes (i.e. dict keys) are as follows:

- `title`: A regular expression which will be applied to the page title.
- `slug`: A regular expression which will be applied to the slug.
- `url`: A regular expression which will be applied to the target URL.
- `path`: A regular expression which will be applied to the path to the markdown
  source file (i.e. the `source_file_short` field).
- `doc`: A regular expression which will be applied to the body of the markdown
  source document.
- `date_range`: A list containing two ISO-formatted dates and optionally a date
  key (`DATE` by default) - see the description of `in_date_range()` above.
- `has_attrs`: A list of frontmatter variable names. Matching pages must have a
  non-empty value for each of them.
- `attrs`: A dict where each key is the name of a frontmatter variable and the
  value is the value of that attribute. If the value is a string, it will be
  matched case-insensitively. All key-value pairs must match.
- `has_tag`, `in_section`, `in_category`: The values are lists of tags, sections
  or categories, respectively, at least one of which must match
  (case-insensitively). See the methods with these names above.
- `is_post`: If set to True, will match if the page is a blog post; if set to
  False will match if the page is not a blog post.
- `exclude_url`: The page with this URL should be omitted from the results
  (normally the calling page).

### Sorting

All of these return a new `MDContentList` object with the entries in the
specified order.

- `sorted_by(self, key, reverse=False, default_val=-1)`: A general sorting
  method. The `key` is the `page` variable to sort on, `default_val` is the
  value to assume if there is no such variable present in the entry, while
  `reverse` indicates whether the sort is to be descending (True) or ascending
  (False, the default).

- `sorted_by_date(self, newest_first=True, date_key='DATE')`: Sorting by date,
  newest first by default. The date key to sort on can be specified if desired.

- `sorted_by_title(self, reverse=False)`: Sorting by `page.title`, ascending
  by default.

### Pagination

- `paginate(self, pagesize=5, context=None)`: Divides the `MDContentList` into
  chunks of size `pagesize` and returns a tuple consisting of the chunks and a
  list of `page_urls` (one for each page, in order). If an appropriate template
  context is provided, pages 2 and up will be written to the webroot output
  directory to destination files whose names are based upon the URL for the
  first page (and the page number, of course). Without the context, the
  `page_urls` will be None. It is the responsibility of the calling template to
  check the `_page` variable for the current page to be rendered (this defaults
  to 1). Each iteration will get all chunks and must use this variable to limit
  itself appropriately.

Typical usage of `paginate()`:

```mako
<%
  posts = MDCONTENT.posts()
  chunks, page_urls = posts.paginate(5, context)
  curpage = context.get('_page', 1)
%>

% for post in chunks[curpage-1]:
  ${ show_post(post) }
% endfor

% if len(chunks) > 1:
  ${ prevnext(len(chunks), curpage, page_urls) }
% endif
```

### Render to an arbitrary file

- `def write_to(self, dest, context, extra_kwargs=None, template=None)`:
  Calls a template with the `MDContentList` in `self` as the value of `CHUNK`
  and write the result to the file named in `dest`. The file is of course
  relative to the webroot.  Any directories are created if necessary. The
  `template` is by default the calling template while `extra_kwargs` may be
  added if desired.

Typical usage of `write_to()`:

```mako
<%
  if not CHUNK:
     for tag in tags:
         tagged = MDCONTENT.has_tag([tag])
         if not tagged:
             continue  # avoid potential infinite loop!
         outpath = '/tags/' + slugify(tag) + '/index.html'
         tagged.write_to(outpath, context, {'TAG': tag})
%>

% if CHUNK:
  ${ list_tagged_pages(TAG, CHUNK) }
% else:
  ${ list_tags() }
% endif
```

