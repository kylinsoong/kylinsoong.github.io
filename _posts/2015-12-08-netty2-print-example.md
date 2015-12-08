---
layout: blog
title:  "Netty 4 Output Example"
date:   2015-12-08 18:25:30
categories: netty
permalink: /netty4-output-example
author: Kylin Soong
duoshuoid: ksoong2015120802
---

Netty 4 Output Example has 2 parts: Server and Client, the Server listen on a socket address, client send message to Server, every time Server received a Message, just output Message to console.

**Netty 4 Output Example Server**

![Netty 4 Server]({{ site.baseurl }}/assets/blog/netty4-output-server.png)

[Completed Source Code](https://raw.githubusercontent.com/kylinsoong/teiid-test/master/server/src/main/java/org/teiid/test/server/netty/NettyServerExample.java)

**Netty 4 Output Example Client**

![Netty 4 Client]({{ site.baseurl }}/assets/blog/netty4-output-client.png)

[Completed Source Code](https://raw.githubusercontent.com/kylinsoong/teiid-test/master/server/src/main/java/org/teiid/test/server/netty/Client.java)

Run the Client send a message to Server, the output like:

~~~
[id: 0x65f541bd, /127.0.0.1:51252 => /127.0.0.1:31001] active
[id: 0x65f541bd, /127.0.0.1:51252 => /127.0.0.1:31001] read: MessageHolder: key=1 contents=Hello Wolrd
[id: 0x65f541bd, /127.0.0.1:51252 :> /127.0.0.1:31001] inactive
~~~
