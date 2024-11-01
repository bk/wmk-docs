---
title: "Site search"
slug: site_search
weight: 140
---


## Site search

### Using Lunr

Lunr is the only search solution "natively" supported by `wmk`. That being said,
implementing site search is not a simple matter of turning lunr indexing on. It
takes a bit of work by the author of the site or theme templates, so depending
on your needs it may even be easier to base your search functionality on another
solution.

With `lunr_index` (and optionally `lunr_index_fields`) in `wmk_config.yaml`, wmk
will build a search index for [Lunr.js](https://lunrjs.com/) and place it in
`idx.json` in the webroot. In order to minimize its size, no metadata about
each record is saved to the index. Instead, a simple list of pages (with title
and summary) is placed in `idx.summaries.json`. The summary is taken either from
one of the frontmatter fields `summary`, `intro` or `description` (in order of
preference) or, failing that, from the start of the page body.

If `lunr_languages` is present in `wmk_config.yaml`, stemming rules for those
languages will be applied when building the index. The value may be a two-letter
lowercase country code (ISO-639-1) or a list of such codes. The currently
accepted languages are `de`, `da`, `en`, `fi`, `fr`, `hu`, `it`, `nl`, `no`,
`pt`, `ro`, and `ru` (this is the intersection of the languages supported by
`lunr.js` and NLTK, respectively). The default language is `en`. Attempting to
specify a non-supported language will raise an exception.

The index is built via the [`lunr.py`](https://lunr.readthedocs.io/en/latest/)
module and the stemming support is provided by the Python [Natural Language
Toolkit](https://www.nltk.org/).

For information about the supported syntax of the search expression, see the
[Lunr documentation](https://lunrjs.com/guides/searching.html).

### Limitations of Lunr

- Building the index does not mean that the search functionality is complete. It
  remains to point to `lunr.js` in the templates and write some javascript to
  interface with it and display the results.  However, since every website is
  different, this cannot be provided by wmk directly. It is up to the template
  (or theme) author to actually load the index and present a search interface to
  the user.

- Similarly, if a "fancy" preview of results is required which cannot be fulfilled
  using the information in `idx.summaries.json`, this must currently be solved
  independently by the template/theme author.

- Note that only the raw content document is indexed, not the HTML after the
  markdown (or other input content) has been processed. The only exception to
  this is that the binary input formats (DOCX, ODT, EPUB) are converted to
  markdown before being indexed. The output of templates (including even text
  resulting from shortcodes called from the content documents) is not indexed
  either.

- Because Lunr creates a single index file for the whole site, it may not be a
  practical  option for large sites with lots of content – a realistic
  limit may be somewhere around 1,000 pages or so. Some other client-side
  search solutions break the index into smaller chunks and may therefore be a
  viable option for such sites.

### Overview of alternative solutions

If you are looking for an alternative to lunr, the first thing to consider is
whether a server-based solution is needed or whether a Javascript-based
client-side solution would be enough.

If the site has a lot of text (more than 200,000 words or so) or if it needs to
work even without Javascript, then a server-based solution is required. You then
need to decide whether you want to self-host it or if you are ready to pay for a
third-party hosted solution.  [Meilisearch](https://www.meilisearch.com/) is
open source and allows for self-hosting (although a hosted solution called
Meilisearch Cloud is also available), while the market leader in hosted site
search is probably [Algolia](https://www.algolia.com/).

If, however, a client-side Javascript solution is sufficient, there are several
alternatives to lunr that could come into consideration, e.g.
[Pagefind](https://pagefind.app/),
[Tinysearch](https://github.com/tinysearch/tinysearch),
[Elasticlunr](http://elasticlunr.com/) or [Stork](https://stork-search.net/).

Whichever solution is picked, you of course need to add the required HTML, CSS
and Javascript to the templates for the search functionality to work. You also
need to take care of updating the search index whenever the site is built.

Assuming you have opted not to use the built-in lunr support, the index
creation/updating step can basically be implemented in two ways:

1. By running after the build step has finished via a `cleanup_commands` entry
   in `wmk_config.yaml`. This calls a script or another external program which
   can update the index based on either the HTML in the output folder or the
   JSON file specified using the `mdcontent_json` configuration option.

2. By implementing a hook function in `wmk_hooks.py` (or `wmk_theme_hooks.py`),
   most likely for `post_build_actions()` or `index_content()`;
   see {{< linkto("Overriding and extending wmk via hooks") >}}.

### Example: Pagefind

Taking Pagefind as an example of the steps described above, you would, per [their
documentation](https://pagefind.app/docs/), add something similar to this to
your templates in an appropriate location:

```html
<link href="/pagefind/pagefind-ui.css" rel="stylesheet">
<script src="/pagefind/pagefind-ui.js"></script>
<div id="search"></div>
<script>
    window.addEventListener('DOMContentLoaded', (event) => {
        new PagefindUI({ element: "#search", showSubResults: true });
    });
</script>
```

It would also be a good idea to make sure you modify all base templates so as to
identify the main part of each page [with the `data-pagefind-body`
attribute](https://pagefind.app/docs/indexing/) and thus omit repeated
elements such as navigation and footer from the index.

Finally, in order to actually create or update the search index whenever the
site is built, you would need to add the following to the `wmk_config.yaml` file:

```yaml
cleanup_commands:
  - "npx -y pagefind --site htdocs"
```

This obviously assumes that you have [npm](https://www.npmjs.com/) installed on
your system.

