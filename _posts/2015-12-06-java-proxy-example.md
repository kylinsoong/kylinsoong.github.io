---
layout: blog
title:  "Java 动态代理使用案例 - Teiid 中动态代理的使用"
date:   2015-12-06 18:30:00
categories: java
author: Kylin Soong
duoshuoid: ksoong2015120601
---

设计模式之代理模式中，代理对象和被代理对象一般实现相同的接口，调用者与代理对象进行交互。代理的存在对于调用者来说是透明的，调用者看到的只是接口。代理对象则可以封装一些内部的处理逻辑，如访问控制、远程通信、日志、缓存等。比如一个对象访问代理就可以在普通的访问机制之上添加缓存的支持。这种模式在RMI和EJB中都得到了广泛的使用。传统的代理模式的实现，需要在源代码中添加一些附加的类。这些类一般是手写或是通过工具来自动生成。JDK 5引入的动态代理机制，允许开发人员在运行时刻动态的创建出代理类及其对象。在运行时刻，可以动态创建出一个实现了多个接口的代理类。
  
~~~
package java.lang.reflect;
public class Proxy implements java.io.Serializable {
    public static Object newProxyInstance(ClassLoader loader,Class<?>[] interfaces,InvocationHandler h)throws IllegalArgumentException {
    }
}
~~~

每个代理类的对象都会关联一个表示内部处理逻辑的InvocationHandler接 口的实现。

~~~
package java.lang.reflect;
public interface InvocationHandler {
    public Object invoke(Object proxy, Method method, Object[] args)throws Throwable;
}
~~~

当使用者调用了代理对象所代理的接口中的方法的时候，这个调用的信息会被传递给InvocationHandler的invoke方法。在 invoke方法的参数中可以获取到代理对象、方法对应的Method对象和调用的实际参数。invoke方法的返回值被返回给使用者。这种做法实际上相 当于对方法调用进行了拦截。熟悉AOP的人对这种使用模式应该不陌生。但是这种方式不需要依赖AOP框架。

下面给出一些 [Teiid 代码](https://github.com/teiid/teiid) 中动态代理的使用的案例.

## 案例一: SocketServerInstance Proxy

![Java Proxies SocketServerInstance Proxy]({{ site.baseurl }}/assets/blog/java-proxies-teiid-socketInsance.png)

* 第 4 行代码实例化了一个 CachedInstance 对象，该对象作为 ShutdownHandler 构造方法参数，参照第 8 行代码，该对象有两个 SocketServerInstance 属性(actual 和 proxy)如下:

![Java Proxies SocketServerInstance Proxy - cacheinstance]({{ site.baseurl }}/assets/blog/java-proxies-teiid-socketInsance-cacheinstance.png)

* 第 5-7 行代码中实例化了一个 SocketServerInstance 的实现（SocketServerInstanceImpl），通过调用 connect() 方法连接到 Teiid Server, 最后将其设置为 CachedInstance 的 actual 属性
* 第 8 行使用 Proxy.newProxyInstance() 方法创建代理，创建完成后将其设置为 CachedInstance 的 proxy 属性，ShutdownHandler 实现主要逻辑如下:

![Java Proxies SocketServerInstance Proxy - shutdown]({{ site.baseurl }}/assets/blog/java-proxies-teiid-socketInsance-handler.png)

> 如上图 invoke() 方法中 13-16 行调运 shutdown() 方法是典型的 **代理对象添加一些处理逻辑的AOP模式**， 19-21 行通过反射来调运 SocketServerInstance 实现的其他方法。

[详细参加 Teiid 源代码](https://raw.githubusercontent.com/teiid/teiid/master/client/src/main/java/org/teiid/net/socket/SocketServerConnectionFactory.java)

## 案例二: ILogon Proxy

![Java Proxies ILogon Proxy]({{ site.baseurl }}/assets/blog/java-proxies-teiid-ilogon.png)

第 4-9 行使用 Proxy.newProxyInstance() 方法创建 ILogon 代理，RemoteInvocationHandler 为 InvocationHandler 的实现，它的 UML 图如下

![Java Proxies ILogon remoteInvocationHandler]({{ site.baseurl }}/assets/blog/teiid-uml-remoteInvocationHandler.png)

RemoteInvocationHandler 有一个抽象方法 getInstance() 用来获取 SocketServerInstance 实现，invoke() 方法中通过 SocketServerInstance 完成发送消息给 Teiid Server 和接收 Teiid Server 返回的消息。

## 案例三: DQP Proxy

![Java Proxies DQP Proxy]({{ site.baseurl }}/assets/blog/java-proxies-teiid-dqp.png)

* 第 6-8 行实现了 RemoteInvocationHandler 的 getInstance() 方法，用来获取 SocketServerInstance 的实现
* 第 11-16 行调运 RemoteInvocationHandler 的 invoke() 方法

DQP Proxy 与 ILogon Proxy 中 RemoteInvocationHandler 相同，都通过 SocketServerInstance 完成发送消息给 Teiid Server 和接收 Teiid Server 返回的消息。

