---
layout: blog
title:  "JBoss MSC 示例"
date:   2015-06-21 21:25:12
categories: jboss
author: Kylin Soong
duoshuoid: ksoong2015062101
excerpt: JBoss MSC(Modular Service Container) 示例  
---

## HelloWorld 示例

HelloWorld 示例演示如何使用 JBoss MSC 部署一个 Service。

Service 的实现如下:

~~~
public class MyService implements Service<Boolean> {	
    final static ServiceName SERVICE = ServiceName.of("helloworld");
    private final String message;
    private Thread thread;
    private boolean active;

    public MyService(String message) {
        this.message = message;
    }

    public void start(final StartContext startContext) throws StartException {
        startContext.asynchronous();
        this.active = true;
        this.thread = new Thread(new Runnable() {
            public void run() {
                startContext.complete();

                while (active) {
                    System.err.println(message);
                    try {
                        Thread.sleep(1000);
                    } catch (InterruptedException e) {
                    	Thread.currentThread().interrupt();
                    }
                }

            }
        });

        this.thread.start();
    }

    public void stop(StopContext stopContext) {
        this.active = false;
    }

    public Boolean getValue() throws IllegalStateException, IllegalArgumentException {
        return active;
    }
}
~~~

如上面代码段:

* MyService 的名字为 helloworld
* MyService 构造方法必需传入一个字符串，且 MyService 包含一个 Thread， Thread 启动后循环输出构造方法中传入的字符串
* MyService getValue 返回当前状态是否 active

接下来演示创建一个 MSC 容器，并且将 MyService 添加到 MSC 容器:

~~~
ServiceContainer container = ServiceContainer.Factory.create(); 
Service<Boolean> service = new MyService("Hello World");
ServiceBuilder<Boolean> builder = container.addService(MyService.SERVICE, service);
builder.install();
Thread.sleep(1000);
System.out.println("MyService isActive:" + service.getValue());
container.dumpServices();
~~~

运行如上代码输出:

~~~
Hello World
MyService isActive:true
Services for anonymous-1:
Service "helloworld" (class org.jboss.msc.quickstart.MyService) mode ACTIVE state UP
1 services displayed
Hello World
Hello World
Hello World
...
~~~ 
