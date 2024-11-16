---
title: "Incorporating external sources"
slug: external_sources
weight: 160
---


## Incorporating external sources

A wmk-maintained website may incorporate material that does not originate as
content files in the site's `content/` directory. The source of the material may
be a database or an external API, perhaps provided by a headless CMS system such
as Sanity, Directus, or DatoCMS.

In either case, there are two main approaches as to how to integrate such
content into a wmk site. The first is to use the hooks system described earlier,
especially `get_extra_content()`. The second is to fetch the material
independently of wmk (or perhaps from the `init_commands` that can be specified
in the configuration file) and write it as a set of html or markdown files into
`content/`, whereupon wmk can treat it as normal file-based content.

### Example: Import from WordPress

As an example of the latter approach, a set of scripts is available in the
`extras/` subdirectory to fetch and maintain content from a WordPress site.

The script `wordpress2content.py` uses the WordPress REST API to get posts and
pages from a WordPress site and export them as content files in `content/`.
Images and other media files from the origin's `wp-content/uploads/` folder go
into `static/_fetched/`.

This may either be used to migrate from WordPress to a static site maintained
by wmk, or to use a (possibly non-public) WordPress installation as a headless
CMS for external authors or non-technical users.

When used in the latter way, the helper scripts `duplicate_wp_content.py` and
`removed_wp_content.py` may help with the housekeeping involved in keeping the
content properly synchronized.

For further details, see the [readme][extras-readme] in the `extras/` directory.

[extras-readme]: https://github.com/bk/wmk/blob/master/extras/readme.md
