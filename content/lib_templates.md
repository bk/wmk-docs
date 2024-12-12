---
title: "Template library"
slug: lib_templates
weight: 105
---


## Template library

It is generally up to the site or theme author to define any needed Mako/Jinja
templates. In rare cases, however, the templates are general enough that it may
be natural to distribute them with wmk itself in the form of a Mako template
library located under `/lib/`.

### seo.mc

The template `/lib/seo.mc` makes it easier to format metadata for use in the
`<head>` section of a base template. It is used in something like the following
way:

```mako
<%namespace import="seo" file="/lib/seo.mc" />
% if page:
  ${ seo(site, page, url=SELF_URL, title=self.page_title) }
% else:
  ${ seo(site, page=None, url=SELF_URL, title=self.page_title,
         img=self.attr.main_image) }
% endif
```

This will add common meta tags (including basic OpenGraph and JSON-LD
information). By default, it also adds a `<title>` tag. For further details
regarding the functionality, see the template file itself.

### atom_xml.mc

The template `/lib/atom_xml.mc` can be used to facilitate the creation of an
Atom feed for the website.  Set `site.base_url` to a valid URL and set
`site.atom_feed` to a true value.  Then create a file named `atom.xml.mhtml` in
the template root, containing something like the following:

```mako
<%namespace name="atom" file="/lib/atom_xml.mc" />\
${ atom.feed(contentlist=MDCONTENT.sorted_by_date()) }\
```

There are several optional parameters (`with_img`, `get_img`, `with_summary`,
`get_summary`, `pubdate_attr`, `updated_attr`, `with_full_text`, `limit`) for
tweaking the output.

### sitemap_xml.mc

Similarly, `/lib/sitemap_xml.mc` can be used to create a `siteamp.xml` file.
Set `site.enable_sitemap` to a true value and ensure that `site.base_url` is present.
Then create a file named `sitemap.xml.mhtml` in the template root, with the
following content:

```mako
<%namespace import="sitemap" file="/lib/sitemap_xml.mc" />\
${ sitemap(contentlist=MDCONTENT) }\
```

### Usage in Jinja templates

No Jinja version of these components has been created, but the Mako version
can be called from a Jinja2 template using code such as the following:

```jinja2
{% set seo = mako_lookup.get_template("/lib/seo.mc").get_def("seo") %}
{{ seo.render(site, page, url=SELF_URL, title=page.title) |safe }}
```

