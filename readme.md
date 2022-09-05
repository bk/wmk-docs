# Documentation for wmk

This is the documentation for the [wmk][wmk] static site builder (and also
itself a wmk website).

- Update the documentation by running `bin/autodoc.pl` in the project directory.
  You will need to have `wmk` installed and in your `$PATH`.

- (Re)build the html (in `htdocs/`) with `wmk b .`.

- Look at the result by running `wmk s .` and open `http://localhost:7007/` in
  your browser.

After initially cloning this repository (before running `wmk b`) you may need
to fetch git submodules with `git submodule update --init`.

[wmk]: https://github.com/bk/wmk/
