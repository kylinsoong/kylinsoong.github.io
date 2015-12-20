---
layout: blog
title:  "java.nio 包中的类"
date:   2015-12-11 19:30:00
categories: java
permalink: /java-nio-class
author: Kylin Soong
duoshuoid: ksoong2015121102
---

java.nio 包中主要包括非阻塞通信相关的类，下图为 java.nio.channels.Channel，java.nio.channels.ServerSocketChannel，java.nio.channels.SocketChannel 等类的相关 UML 图

![Channel UML]({{ site.baseurl }}/assets/blog/java-nio-channel.png)

* ServerSocketChannel: ServerSocket 的替代类，支持阻塞通信和非阻塞通信
* SocketChannel: Socket 的替代类，支持阻塞通信和非阻塞通信

另为除了 ServerSocketChannel 和 SocketChannel，java.nio.channels.Selector，java.nio.channels.SelectionKey 也是非阻塞通信中重要的相关类

* Selector: 为 ServerSocketChannel 监控接收连接就绪事件， 为 SocketChannel 监控连接就绪，读就绪和写就绪事件。
* SelectionKey: 代表 ServerSocketChannel 和 SocketChannel 向 Selector 注册事件的句柄。当一个 SelectionKey 对象位于 Selector 对象的 selected-keys 集合中时，就表示与这个 SelectionKey 对象相关的事件发生了。

如 UML 图中所示，ServerSocketChannel，SocketChannel 及 DatagramChannel 都是 SelectableChannel 的子类。 SelectableChannel 类及其子类都是委托 Selector 来监控它们可能发生的一些事件，这种委托的过程也称为注册事件的过程.

**四种事件:** `接收连接就绪事件`, `连接就绪事件`, `读就绪事件`, `写就绪事件`

这四种事件分别用 SelectionKey 类的一些静态常量表示，依次是: OP_ACCEPT, OP_CONNECT, OP_READ, OP_WRITE. 且 ServerSocketChannel 只可能发生一种事件：

* SelectionKey.OP_ACCEPT - `接收连接就绪事件`，表示至少有一个客户连接，服务器可以接收这个连接。

SocketChannel 可能发生以下三种事件：

* SelectionKey.OP_CONNECT - `连接就绪事件`，表示客户与服务器的连接已经建立成功。
* SelectionKey.OP_READ - `读就绪事件`，表示输入流已经有了可读数据，可以执行读操作。
* SelectionKey.OP_WRITE - `写就绪事件`，表示可以向输出流写数据。

**Selector 定义的方法**

![Selector UML]({{ site.baseurl }}/assets/blog/java-nio-selector.png)

static Selector open() 用来创建 Selector，select() 方法选择一个通道，如果没有通道连接时，该方法处于阻塞状态

![Selector block]({{ site.baseurl }}/assets/blog/java-nio-selector-block.png)

**Selector 注册事件**

ServerSocketChannel 向 Selector 注册`接收连接就绪事件`的代码如下

~~~
serverSocketChannel.register(selector, SelectionKey.OP_ACCEPT);
~~~

SocketChannel 向 Selector 注册 `读就绪事件`, `写就绪事件` 的代码如下

~~~
socketChannel.register(selector, SelectionKey.OP_READ | SelectionKey.OP_WRITE); 
~~~

**SocketChannel 提供了接收和发送数据的方法**

* read(ByteBuffer dst) - 接收数据，把它们存放到参数指定的 ByteBuffer 中
* write(ByteBuffer src) - 把参数指定的 ByteBuffer 中的数据发送出去

## 非阻塞通信示例

[NioEchoServer.java](https://raw.githubusercontent.com/kylinsoong/teiid-test/master/server/src/main/java/org/teiid/test/server/netty/nio/NioEchoServer.java)

[NioEchoClient.java](https://raw.githubusercontent.com/kylinsoong/teiid-test/master/server/src/main/java/org/teiid/test/server/netty/nio/NioEchoClient.java)
