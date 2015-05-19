---
layout: blog
title:  "Teiid Results Caching Usage Example"
date:   2015-05-19 21:20:00
categories: teiid
permalink: /teiid-rs-cache
author: Kylin Soong
duoshuoid: ksoong2015051901
excerpt: Teiid Results Caching Example
---

Let's start from a test case, there are 100 MB size data exist in Mysql Data Base, then we create View in Teiid VDB query against these data, the result as figure: 

![Teiid rs cache]({{ site.baseurl }}/assets/blog/teiid-perf-resultset.png)

In the Figure, the left histogram is query without cache, the right histogram is with cache, we can get the conclusion: enable Cache is 1000 times fast than without cache.

