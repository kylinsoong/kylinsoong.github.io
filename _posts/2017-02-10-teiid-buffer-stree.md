---
layout: blog
title:  "Teiid BufferManager - STree"
date:   2017-02-11 20:00:00
categories: teiid
permalink: /teiid-buffer-stree
author: Kylin Soong
duoshuoid: ksoong2017021002
excerpt: Understanding Teiid BufferManager - STree, SPage
---

* Table of contents
{:toc}

## Steps

This article contains a series of buffer snapshot for creating a `STree`, and add a series of `Tuple` to `STree`, a `Tuple` contains 5 elements, the first 2 elements play as primary key, each time one `Tuple` be inserted.

### 0. Create

![STree - 0]({{ site.baseurl }}/assets/blog/teiid/teiid-buffer-stree-0.png)

### 1. Insert [1, name-1, 123456789, Beijing, CN]

![STree - 1]({{ site.baseurl }}/assets/blog/teiid/teiid-buffer-stree-1.png)

### 2. Insert [2, name-2, 123456789, Beijing, CN]

![STree - 2]({{ site.baseurl }}/assets/blog/teiid/teiid-buffer-stree-2.png)

### 3. Insert [3, name-3, 123456789, Beijing, CN]

![STree - 3]({{ site.baseurl }}/assets/blog/teiid/teiid-buffer-stree-3.png)

### 4. Insert [4, name-4, 123456789, Beijing, CN]

![STree - 4]({{ site.baseurl }}/assets/blog/teiid/teiid-buffer-stree-4.png) 

### 5. Insert [5, name-5, 123456789, Beijing, CN]

![STree - 5]({{ site.baseurl }}/assets/blog/teiid/teiid-buffer-stree-5.png)

### 6. Insert [6, name-6, 123456789, Beijing, CN]

![STree - 6]({{ site.baseurl }}/assets/blog/teiid/teiid-buffer-stree-6.png)

### 7. Insert [7, name-7, 123456789, Beijing, CN]

![STree - 7]({{ site.baseurl }}/assets/blog/teiid/teiid-buffer-stree-7.png)

### 8. Insert [8, name-8, 123456789, Beijing, CN]

![STree - 8]({{ site.baseurl }}/assets/blog/teiid/teiid-buffer-stree-8.png)

### 9. Insert [9, name-9, 123456789, Beijing, CN]

![STree - 9]({{ site.baseurl }}/assets/blog/teiid/teiid-buffer-stree-9.png)

### 10. Insert [10, name-10, 123456789, Beijing, CN]

![STree - 10]({{ site.baseurl }}/assets/blog/teiid/teiid-buffer-stree-10.png)

### 11. Insert [11, name-11, 123456789, Beijing, CN]

![STree - 11]({{ site.baseurl }}/assets/blog/teiid/teiid-buffer-stree-11.png)

### 12. Insert [12, name-12, 123456789, Beijing, CN]

![STree - 12]({{ site.baseurl }}/assets/blog/teiid/teiid-buffer-stree-12.png)

### 13. Insert [13, name-13, 123456789, Beijing, CN]

![STree - 13]({{ site.baseurl }}/assets/blog/teiid/teiid-buffer-stree-13.png)

### 14. Insert [14, name-14, 123456789, Beijing, CN]

![STree - 14]({{ site.baseurl }}/assets/blog/teiid/teiid-buffer-stree-14.png)

### 15. Insert [15, name-15, 123456789, Beijing, CN]

![STree - 15]({{ site.baseurl }}/assets/blog/teiid/teiid-buffer-stree-15.png)

### 16. Insert [16, name-16, 123456789, Beijing, CN]

![STree - 16]({{ site.baseurl }}/assets/blog/teiid/teiid-buffer-stree-16.png)
