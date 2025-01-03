---
title: "Usage: The wmk command"
slug: usage
weight: 30
---


## Usage

The `wmk` command structure is `wmk <action> <base_directory>`. The base
directory is of course the directory containing the source files for the site.
(They are actually in subdirectories such as `templates`, `content`, etc. –
see {{< linkto("File organization") >}}).

- `wmk info $basedir`: Shows the real path to the location of `wmk.py` and of
  the content base directory. E.g. `wmk info .`. Synonyms for `info` are `env`
  and `debug`.

- `wmk init $basedir`: In a folder which contains `content/` (with markdown
  or HTML files) but no `wmk_config.yaml`, creates some initial templates as
  well as a sample `wmk_config.yaml`, thus making it quicker for you to start a
  new project.

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

- `wmk preview $basedir $filename` where `$filename` is the name of a file relative
  to the `content` subdirectory of `$basedir`. This prints (to stdout) the HTML
  which the given file will be converted to (before it is passed to the
  template and before potential post-processing). Example: `wmk preview .
  index.md`.

- `wmk admin $basedir`: Build the site and then start [wmkAdmin](https://github.com/bk/wmk-admin/),
  which must have been installed beforehand into the `admin` subdirectory of the
  `$basedir` (or into the subdirectory specified with `wmk admin $basedir $subdir`).
  The subdirectory may be a symbolic link pointing to a central instance.
  wmkAdmin allows you to manage the content of the site via a web interface. It
  is not designed to allow you to install or modify themes or perform tasks that
  require more technical knowledge, and works best for a standard site based on
  Markdown or HTML files in the `content` directory.

- `wmk repl $basedir`: Launch a Python shell (ipython, bpython or python3, in
  order of preference) with the wmk environment loaded and with the `$basedir`
  as current working directory. Useful for examining wmk's view of the site
  content or debugging `MDContent` filtering methods. For these purposes, `from
  wmk import get_content_info`, followed by `content = get_content_info('.')` is
  often a good start.

- `wmk pip <pip-command>`: Run `pip` in the virtual environment used by wmk.
  Mainly useful for installing or upgrading Python modules that you want to use
  in Python files belonging to your projects.

- `wmk homedir`: Outputs the path to `wmk`'s installation directory. May be
  useful in shell scripts.

