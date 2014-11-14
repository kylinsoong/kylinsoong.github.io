---
layout: blog
title:  "ksoong.org Dev Journal"
date:   2014-07-18 17:57:12
categories: jekyll
author: Kylin Soong
duoshuoid: ksoong20140718
---

This article contains journals in developing [ksoong.org](ksoong.org).


## weibo feeds flash

添加如下一行 html 代码可嵌入 weibo feeds flash:

~~~
<iframe width="302" height="552"  scrolling="no" frameborder="0" src="http://service.weibo.com/staticjs/weiboshow.swf?verifier=5089da68&uid=1803641581&width=300&height=600&fansRow=1&isTitle=1&isWeibo=1&isFans=0&noborder=0&ptype=1&colors=cfe1f3,fafcff,444444,5093d5"></iframe>
~~~

* width - swf 宽
* height - swf 高
* uid - Weibo 帐号 uid
* isFans - 是否显示好友，0不显示，1显示
* fansRow - 显示好友的行数，只有在 isFans 为1是才起作用

## duoshuo 评论框

The following steps used to add duoshuo framework to [ksoong.org](ksoong.org):

* Register a user from [duoshuo.com](http://duoshuo.com/)

> Note 'ksoong' is my id, [link](http://ksoong.duoshuo.com) is my duoshuo admin page.

* Add duoshuo id to `_config.yml`

~~~
duoshuo:
  config: true
  id: ksoong
~~~

* Load the duoshuo script in `_layouts/default.html`

~~~
            <script type="text/javascript">
                var duoshuoQuery = {short_name:"{{ site.duoshuo.id }}"};
                (function() {
                    var ds = document.createElement('script');
                    ds.type = 'text/javascript';
                    ds.async = true;
                    ds.src = (document.location.protocol == 'https:' ? 'https:' : 'http:') + '//static.duoshuo.com/embed.js';
                    ds.charset = 'UTF-8';
                    (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(ds);
                })();
            </script>
~~~

* Add duoshuo comments box

~~~
<div class="ds-thread" data-thread-key="{{ page.duoshuoid }}" data-title="{{ page.title }}" data-url="{{site.url}}{{ page.url }}"></div>
~~~
