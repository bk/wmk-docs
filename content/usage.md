---
title: "Usage: The wmk command"
slug: usage
weight: 30
---


## Usage

The `wmk` command structure is `wmk <action> <base_directory>`. The base
directory is of course the directory containing the source files in
subdirectories such as `templates`, `content`, etc.  Also
see {{< linkto("File organization") >}}.

- `wmk info $basedir`: Shows the real path to the location of `wmk.py` and of
  the content base directory. E.g. `wmk info .`. Synonyms for `info` are `env`
  and `debug`.

- `wmk init $basedir`: In a folder which contains `content/` (with Markdown
  files) but no `wmk_config.yaml`, creates some initial templates as well
  as a sample `wmk_config.yaml`, thus making it quicker for you to start a new
  project.

- `wmk build $basedir [-q|--quick]`: Compiles/copies files into `$basedir/htdocs`.
  If `-q` or `--quick` is specified as the third argument, only files considered to
  have changed, based on timestamp checking, are processed. Synonyms for `run` are
  `run`, `b` and `r`.

- `wmk watch $basedir`: Watches for changes in the source directories inside
  `$basedir` and recompiles if changes are detected. (Note that `build` is not
  performed automatically before setting up file wathcing, so you may want to
  run that first). A synonym for `watch` is `w`.

- `wmk serve $basedir [-p|--port <portnum>] [-i|--ip <ip-addr>]`: Serves the
  files in `$basedir/htdocs` on `http://127.0.0.1:7007/` by default. The IP and
  port can be modified with the `-p` and `-i` switches or be be configured via
  `wmk_config.yaml` – see {{< linkto("Configuration file") >}}). Synonyms for
  `serve` are `srv` and `s`.

- `wmk watch-serve $basedir [-p|--port <portnum>] [-i|--ip <ip-addr>]`: Combines
  `watch` and `serve` in one command. Synonym: `ws`.

- `wmk clear-cache $basedir`: Remove the HTML rendering cache, which is a SQLite
  file in `$basedir/tmp/`. This should only be necessary in case of changed
  shortcodes or shortcode dependencies. Note that the cache can be disabled in
  `wmk_config.yaml` by setting `use_cache` to `false`, or on file-by-file basis
  via a frontmatter setting (`no_cache`). A synonym for `clear-cache` is `c`.

