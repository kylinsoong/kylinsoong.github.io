---
layout: blog
title:  "Understanding Teiid BufferManager"
date:   2015-05-10 17:00:00
categories: teiid
permalink: /teiid-buffer
author: Kylin Soong
duoshuoid: ksoong2015051001
excerpt: How Teiid BufferManager running and processing...
---

As below figure, the key interface of Teiid BufferManager is `BufferManager`, it extends of interface `StorageManager` and `TupleBufferCache`.

![BufferManager UML]({{ site.baseurl }}/assets/blog/teiid-buffer.png)

The buffer manager controls how memory is used and how data flows through the system. It uses `StorageManager` to retrieve data, store data, and transfer data. The buffer manager has algorithms that tell it when and how to store data. The buffer manager should also be aware of memory management issues.
