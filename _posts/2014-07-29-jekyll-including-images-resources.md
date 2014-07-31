---
layout: blog
title:  "How to include image and resource"
date:   2014-07-29 17:57:12
categories: Teiid
author: Kylin Soong
duoshuoid: ksoong 20140729
---

Use the Following Steps can include images and resources in a post:

* Create a folder in the root of the project directory called something like `assets` or `downloads`

* Put the images and resources to the folder created

* Use the `site.url` variable in a post to include images and resources

**Including an image asset in a post:**

~~~
![My helpful screenshot]({{ site.url }}/assets/screenshot.jpg)
~~~

**Linking to a PDF for readers to download:**

~~~
you can [get the PDF]({{ site.url }}/assets/mydoc.pdf) directly.
~~~

> Note `site.url` refer to *url* parameter in *_config.yml*

## Examples

This section contain examples for including images and resources.

### Including images

This following figure show data federation VDB:

![Federation VDB]({{ site.url }}/assets/portfolio.png)

### Including resources

Dowload the `libreoffice-pdf-export.pdf` from below link:

[download]({{ site.url }}/assets/libreoffice-pdf-export.pdf)
