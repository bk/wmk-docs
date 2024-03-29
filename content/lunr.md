---
title: "Site search using Lunr"
slug: lunr
weight: 140
---


## Site search using Lunr

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
`lunr.js` and NLTK, respecively). The default language is `en`. Attempting to
specify a non-supported language will raise an exception.

The index is built via the [`lunr.py`](https://lunr.readthedocs.io/en/latest/)
module and the stemming support is provided by the Python [Natural Language
Toolkit](https://www.nltk.org/).

For information about the supported syntax of the search expression, see the
[Lunr documentation](https://lunrjs.com/guides/searching.html).

Note that because Lunr creates a single index file for the whole site, it may
not be a practical  option for large sites with lots of content – a realistic
limit may be somewhere around 1,000 pages or so. In such a case, you may want to
consider using solutions that break the index up into smaller chunks, such as
[Pagefind](https://pagefind.app/). Alternatively, you should look into a
server-side or hosted solution such as [Algolia](https://www.algolia.com/) or
[Meilisearch](https://www.meilisearch.com/).

### Limitations

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
  markdown before being indexed. The output of Mako templates (including
  shortcodes called from the content documents) is not indexed either.
