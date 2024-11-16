---
title: "Overriding and extending wmk via hooks"
slug: hooks
weight: 150
---


## Overriding and extending wmk via hooks

Much of the functionality of `wmk` can be changed by overriding or extending
specific steps it performs. This is done by adding Python code to a file named
`wmk_hooks.py` in the project `py/` directory. Themes can do the same thing via
the `wmk_theme_hooks.py` file in the theme's `py/` directory. If both try to
affect the same functionality, the project directory takes precedence.

Currently, the following defs from `wmk.py` can be extended by running hooks
before or after them, or can be redefined entirely:

- `auto_nav_from_content`
- `binary_to_markdown`
- `build_lunr_index`
- `copy_static_files`
- `doc_with_yaml`
- `fingerprint_assets`
- `generate_summary`
- `get_assets_map`
- `get_content_extensions`
- `get_content`
- `get_extra_content`
- `get_index_yaml_data`
- `get_nav`
- `get_template_lookup`
- `get_template_vars`
- `get_templates`
- `handle_redirects`
- `handle_shortcode`
- `handle_taxonomy`
- `index_content`
- `locale_and_translation`
- `lunr_summary`
- `markdown_extensions_settings`
- `maybe_extra_meta`
- `maybe_save_mdcontent_as_json`
- `pandoc_extra_formats`
- `pandoc_metadata`
- `parse_dates`
- `post_build_actions`
- `postprocess_html`
- `preferred_date`
- `process_assets`
- `process_content_item`
- `process_markdown_content`
- `process_templates`
- `render_markdown`
- `run_init_commands`
- `run_cleanup_commands`
- `write_redir_file`

In order to override any of these entirely, define a function of the same name
in the hooks file. One may also define a function that runs before or after:

- A function that runs before any of the above has the same name but with
  `__before` appended, e.g. `index_content__before`. It receives the arguments
  passed to the original function and can modify them and return new arguments
  in the form of either a two-tuple of a list and a dict (for `*args` and
  `**kwargs`) or a single dict (for `**kwargs` only). In either case, these will
  be passed to the affected function instead of the original arguments. If the
  before hook function returns nothing, the original arguments will be passed on
  unchanged.
- A function that runs after any of the above has the same name but with
  `__after` appended, e.g. `index_content__after`. It receives the return value
  of the original function and can return a new value that will be returned
  to the caller instead. (If it returns nothing, the original return value will
  be returned unchanged).

You should examine wmk's source code to make sure that any replacement function
you may write is compatible with the original in terms of its parameters and
possible return values. Updates to `wmk` may of course make it necessary to
change your hook functions.

### Examples

Here is a generic `get_extra_content()` def which adds HTML pages fetched from a
database to the "normal" content from the `content/` directory:

```python
def get_extra_content(content, ctdir, datadir, outputdir, template_vars, conf):
    known_ids = set([_['data']['page']['id'] for _ in content])
    content_extensions = { '.html': {'raw': True}, }
    extpat = re.compile(r'\.html$')
    result = _get_articles_from_database()
    for i, row in enumerate(result):
        meta, doc, pseudo = _munge_row(row, i, result, ctdir)
        wmk.process_content_item(
            meta, doc, content, conf, template_vars,
            ctdir, outputdir, datadir, content_extensions, known_ids,
            pseudo['root'], pseudo['fn'],
            pseudo['source_file'], pseudo['source_file_short'],
            extpat, False)
```

The functions `_get_articles_from_database()` and `_munge_row()` are left as an
exercise for the reader.

Here is an `__after` hook for `maybe_extra_meta()` which fetches a conference
schedule (e.g. from from an online calendar) if the `conference_id` key is
present in the frontmatter.  The retrieved information will then be available to
the templates for that page as `page.schedule`.

```python
def maybe_extra_meta__after(meta):
    if 'conference_id' in meta:
        meta['schedule'] = _get_conference_schedule(meta['conference_id'])
    return meta
```

A third example: Let's say you want to show information from a few RSS sources
in a sidebar that will appear on several pages. In order to avoid refetching it
for each page you can use something like this:

```python
def get_template_vars__after(template_vars):
    if 'rss_sources' in template_vars:
        template_vars['rss_info'] = fetch_rss_feeds(template_vars['rss_sources'])
    return template_vars
```

This assumes that you set `rss_sources` in the `template_context` section of
your `wmk_config.yaml` file.

