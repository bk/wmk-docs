---
title: "Input formats"
slug: input_formats
weight: 45
---


## Input formats

The format of the files in the `content/` directory is determined on the basis
if their file extension. The following extensions are recognized:

- `.md`, `.mdwn`, `.mdown`, `.markdown`, `.gfm`, `.mmd`: Markdown files.  If
  Pandoc is being used, the input formats `.gfm` and `.mmd` will be assumed to
  be `gfm` (Github-flavored markdown) and `markdown_mmd` (MultiMarkdown),
  respectively. (Currently metadata given in MultiMarkdown format is not picked
  up automatically in `.mmd` files, so YAML frontmatter should be used as well).

- `.htm`, `.html`: HTML. These are typically not standalone HTML documents but
  will be "wrapped" by the configured layout template. Like other input files,
  they may have a YAML frontmatter block.

- `.tex`: LaTeX format. Currently ConTeXt is not supported.

- `.org`: Org-mode format.

- `.rst`: ReStructured Text format (RST).

- `.textile`: Textile markup format.

- `.man`: Roff man format.

YAML frontmatter is supported for all the above formats. If it is omitted,
inherited metadata will be used. In addition, the metadata seen by Pandoc for
four of the formats, namely LaTeX, Org, RST and man, will be used as a fallback.
(Common metadata keys discoverable in this way are `title`, `author` and `date`).

Pandoc is turned on automatically for all non-markdown, non-HTML formats.
In order to use such content, Pandoc must be installed.

Most of what is said in the following about markdown content applies to all of
the above input formats.

