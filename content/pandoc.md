---
title: "A note on Pandoc"
slug: pandoc
weight: 80
---


## A note on Pandoc

Pandoc's variant of markdown is very featureful and sophisticated, but since its
use in `wmk` involves spawning an external process for each content file being
converted, it is quite a bit slower than Python-Markdown. Therefore, it is
only recommended if you really do need it. Often, even if you do, it can be
turned on for individual pages or site sections rather than for the entire site.
(Of course, if you are working with non-markdown, non-HTML input content, using
Pandoc is unavoidable.)

If you decide to use Pandoc for a medium or large site (or if you have a
significant amount of non-markdown content), it is recommended to turn the
`use_cache` setting on in the configuration file. When doing this, be aware that
content that is sensitive to changes apart from the content file itself will
need to be marked as non-cacheable by adding `no_cache: true` to the
frontmatter. If you for instance call the `pagelist()` shortcode in the page,
you would normally want to mark the file in this way.

The `markdown_extensions` setting will of course not affect `pandoc`, but there
is one extension which is partially emulated in `wmk`'s Pandoc setup, namely
[toc](https://python-markdown.github.io/extensions/toc/).

If the `toc` frontmatter variable is true and the string `[TOC]` is
present as a separate line in a document which is to be processed by pandoc,
then it will be asked to generate a table of contents which will be placed in
the indicated location, just like the `toc` extension for Python-Markdown does.
The `toc_depth` setting (whose default value is 3) is respected as well,
although only in its integer form and not as a range (such as `"2-4"`). This
applies not only to markdown documents but also to the non-markdown formats
handled by Pandoc.

