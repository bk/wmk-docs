---
title: "A few gotchas"
slug: gotchas
weight: 50
---


## A few gotchas

When creating a website with wmk, you might want to keep the following things in
mind lest they surprise you:

* The order of operations is as follows: (1) Copy files from `static/`; (2) run
  asset pipeline; (3) render Mako templates from `templates`; (4) render
  markdown content from `content`. As a consequence, later steps **may
  overwrite** files placed by earlier steps. This is intentional but definitely
  something to keep in mind.

* For the `run` and `watch` actions when `-q` or `--quick` is specified as a
  modifier, `wmk.py` uses timestamps to prevent unnecessary re-rendering of
  templates, markdown files and SCSS sources. The check is rather primitive and
  does not take account of such things as shortcodes or changed dependencies
  in the template chain. As a rule, `--quick` is therefore **not recommended**
  unless you are working on a small, self-contained set of content files.

* If templates or shortcodes have been changed it may sometimes be necessary to
  clear out the page rendering cache with `wmc c`. During development you may
  want to add `use_cache: no` to the `wmk_config.yaml` file. Also, some pages
  should never be cached, in which case it is a good idea to add `no_cache: true`
  to their frontmatter.

* If files are removed from source directories the corresponding files in
  `htdocs/` **will not disappear** automatically. You have to clear them out
  manually – or simply remove the entire directory and regenerate.

