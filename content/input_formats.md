---
title: "Input formats"
slug: input_formats
weight: 45
---


## Input formats

The format of the files in the `content/` directory is determined on the basis
if their file extension. The following extensions are recognized by default:

- `.md`, `.mdwn`, `.mdown`, `.markdown`, `.gfm`, `.mmd`: Markdown files.  If
  Pandoc is being used, the input formats `.gfm` and `.mmd` will be assumed to
  be `gfm` (Github-flavored markdown) and `markdown_mmd` (MultiMarkdown),
  respectively. Note, however, that currently non-YAML metadata given in
  MultiMarkdown format is not picked up automatically in `.mmd` files).

- `.htm`, `.html`: HTML. These are typically not standalone HTML documents but
  will be "wrapped" by the configured layout template. Like other input files,
  they may have a YAML frontmatter block.

- `.tex`: LaTeX format. Currently ConTeXt is not supported.

- `.org`: Org-mode format.

- `.rst`: ReStructured Text format (RST).

- `.textile`: Textile markup format.

- `.man`: Roff man format.

- `.rtf`: Rich Text Format (RTF).

- `.jats`, `.xml`: The XML-based JATS (Journal Article Tag Suite) format.

- `.docbook`: The XML-based DocBook format.

- `.tei`: The Simple variant of the XML-based TEI (Text Encoding Intiative)
  format.

- `.docx`: MS Word DOCX a.k.a. "Office Open XML" format.

- `.odt`: OpenDocument Text format.

- `.epub`: The EPUB e-book format.

Pandoc is turned on automatically for all non-markdown, non-HTML formats in the
above list.  In order to use such content, Pandoc therefore *must* be installed.

The list of input formats and how they are handled is configurable through the
`content_extensions` setting in the config file.
See {{< linkto("Configuration file") >}} for details.

**Note:** The three formats JATS, DocBook and TEI are all XML-based. Files in
all three formats would therefore often use the generic `.xml` extension.
However, `wmk` currently assumes that `.xml` implies that the JATS format is
intended. If you want to force `wmk` to handle a file with that extension as
DocBook or TEI, you would have to add an external YAML metadata file with
`pandoc_input_format` set to the appropriate value.

In-file YAML frontmatter is supported for all of the above except for the three
binary formats DOCX, ODT and EPUB. Of course, metadata from an associated
external YAML file or inherited metadata applies in all cases. In addition, the
"native" metadata seen by Pandoc for most of the formats (more precisely all
non-markdown, non-HTML formats other than Textile, which uses YAML frontmatter
natively) will be used as a fallback source of in-file metadata, although this
is limited to specific standard keys such as `title`, `author` and `date`.

Note that although other input formats are supported, the *canonical* format is
still markdown. Unless there is a special reason to do otherwise it is the most
sensible and efficient choice for websites generated using `wmk`.



