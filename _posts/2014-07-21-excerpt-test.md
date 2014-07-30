---
layout: blog
title:  "Post excerpt"
date:   2014-07-21 17:57:12
categories: jekyll
excerpt: "<p/>Primary purpose of this article is for how to set a post excerpt"
author: Kylin Soong
---

Each post automatically takes the first block of text, from the beginning of the content to the first occurrence of `excerpt_separator`, and sets it as the `post.excerpt`. Take the above example of an index of posts. Perhaps you want to include a little hint about the post’s content by adding the first paragraph of each of your posts:

~~~
<ul>
  {% for post in site.posts %}
    <li>
      <a href="{{ post.url }}">{{ post.title }}</a>
      {{ post.excerpt }}
    </li>
  {% endfor %}
</ul>
~~~

Because Jekyll grabs the first paragraph you will not need to wrap the excerpt in `p` tags, which is already done for you. These tags can be removed with the following if you’d prefer:

~~~
{{ post.excerpt | remove: '<p>' | remove: '</p>' }}
~~~

If you don’t like the automatically-generated post excerpt, it can be overridden by adding `excerpt` to your post’s YAML front-matter. Completely disable it by setting your `excerpt_separator` to "".
