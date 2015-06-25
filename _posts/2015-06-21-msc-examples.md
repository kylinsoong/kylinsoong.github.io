---
layout: blog
title:  "JBoss MSC 示例"
date:   2015-06-21 21:25:12
categories: jboss
author: Kylin Soong
duoshuoid: ksoong2015062101
excerpt: JBoss MSC(Modular Service Container) 示例  
---

本文包括如下示例:

* HelloWorld 示例
* Service Hierarchy 示例
* Service lifecycle 示例
* Service Dependency 示例

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

## Service Hierarchy 示例

Service Hierarchy 示例演示 MSC 容器加载树装结构的 Service。

假设 Service A 的子 Service 为 B, Service B 的子 Service 为 C，代码如下:

~~~
public static class A implements Service<A> {
		
	public static final ServiceName NAME = ServiceName.of("A");

	public A getValue() throws IllegalStateException,IllegalArgumentException {
		return this;
	}

	public void start(StartContext context) throws StartException {		
		ServiceTarget serviceTarget = context.getChildTarget();
		ServiceBuilder<B> builder = serviceTarget.addService(B.NAME, new B());
		builder.install();
	}

	public void stop(StopContext context) {			
	}
} 
	
public static class B implements Service<B> {
		
	public static final ServiceName NAME = ServiceName.of("B");

	public B getValue() throws IllegalStateException,IllegalArgumentException {
		return this;
	}

	public void start(StartContext context) throws StartException {		
		ServiceTarget serviceTarget = context.getChildTarget();
		ServiceBuilder<C> builder = serviceTarget.addService(C.NAME, new C());
		builder.install();
	}

	public void stop(StopContext context) {			
	}
}
	
public static class C implements Service<C> {
		
	public static final ServiceName NAME = ServiceName.of("C");

	public C getValue() throws IllegalStateException,IllegalArgumentException {
		return this;
	}

	public void start(StartContext context) throws StartException {		
	}

	public void stop(StopContext context) {			
	}
}
~~~

创建 MSC 容器，加载Services:

~~~
ServiceContainer container = ServiceContainer.Factory.create("Hierarchy Service"); 
ServiceBuilder<A> builder = container.addService(A.NAME, new A());
builder.install();
Thread.sleep(1000);
container.dumpServices();
~~~

运行如上代码输出:

~~~
Services for Hierarchy Service:
Service "A" (class org.jboss.msc.quickstart.HierarchyService$A) mode ACTIVE state UP
Service "B" (class org.jboss.msc.quickstart.HierarchyService$B) mode ACTIVE state UP (parent: A)
Service "C" (class org.jboss.msc.quickstart.HierarchyService$C) mode ACTIVE state UP (parent: B)
3 services displayed
~~~ 

## Service lifecycle 示例

MSC 容器中 Service 的状态有很 fine-grained 的定义，如 [MSC 文档](https://docs.jboss.org/author/display/MSC/Services) 中图片所描述，Service lifecycle 示例来演示 MSC 容器中的 Service 的状态变化。

TestService 实现如下:

~~~
public static class TestService implements Service<TestService>  {
		
	public static final ServiceName NAME = ServiceName.of("test.status");
		
	private boolean isFailed;
		
	public TestService(boolean isFailed) {
		this.isFailed = isFailed;
	}

	@Override
	public TestService getValue() throws IllegalStateException,IllegalArgumentException {
		return this;
	}

	@Override
	public void start(StartContext context) throws StartException {
		if(isFailed)
			throw new StartException();
	}

	@Override
	public void stop(StopContext context) {
	}
}
~~~

### STARTING -> UP -> STOPPING -> DOWN -> REMOVED

创建 MSC 容器，初始化 TestService 是传入 isFailed 为 false 如下:

~~~
ServiceContainer container = ServiceContainer.Factory.create("ServiceStatusTransition"); 
Service<TestService> service = new TestService(false)
ServiceBuilder<TestService> builder = container.addService(TestService.NAME, service);
ServiceController<TestService> controller = builder.install();
controller.addListener(new AbstractServiceListener<TestService>(){

	@Override
	public void transition(ServiceController<? extends TestService> controller,Transition transition) {
		System.out.println(transition);
	}});
Thread.sleep(1000);
container.shutdown();
~~~

运行如上代码输出:

~~~
transition from START_INITIATING to STARTING
transition from STARTING to UP
transition from UP to STOP_REQUESTED
transition from STOP_REQUESTED to STOPPING
transition from STOPPING to DOWN
transition from REMOVING to REMOVED
~~~ 

### STARTING -> START_FAILED -> DOWN -> REMOVED

类似上面创建 MSC 容器，初始化 TestService 是传入 isFailed 为 true，则 TestService 启动失败它会进入 START_FAILED 状态

## Service Dependency 示例

MSC 容器中的 Service 可以相互依赖，本示例演示 Service Dependency。

Service A 依赖 Service B 和 C，Service A，B，C 的实现如下:

~~~
public static class A implements Service<A> {
		
	private final InjectedValue<B> b = new InjectedValue<B>();
	private final InjectedValue<C> c = new InjectedValue<C>();
		
	public static final ServiceName NAME = ServiceName.of("A");

	public A getValue() throws IllegalStateException,IllegalArgumentException {
		return this;
	}

	public void start(StartContext context) throws StartException {		
	}

	public void stop(StopContext context) {			
	}
} 
	
public static class B implements Service<B> {
		
	public static final ServiceName NAME = ServiceName.of("B");

	public B getValue() throws IllegalStateException,IllegalArgumentException {
		return this;
	}

	public void start(StartContext context) throws StartException {		
	}

	public void stop(StopContext context) {			
	}
}
	
public static class C implements Service<C> {
		
	public static final ServiceName NAME = ServiceName.of("C");

	public C getValue() throws IllegalStateException,IllegalArgumentException {
		return this;
	}

	public void start(StartContext context) throws StartException {		
	}

	public void stop(StopContext context) {			
	}
}
~~~

创建 MSC 容器，加载相应的 Service:

~~~
ServiceContainer container = ServiceContainer.Factory.create("ServiceDependency"); 
A service = new A();
ServiceBuilder<A> builder = container.addService(A.NAME, service);
builder.addDependency(B.NAME, B.class, service.b);
builder.addDependency(C.NAME, C.class, service.c);
builder.install();
container.addService(B.NAME, new B()).install();
container.addService(C.NAME, new C()).install();
Thread.sleep(1000);
container.dumpServices();
~~~

运行如上代码输出:

~~~
Services for ServiceDependency:
Service "A" (class org.jboss.msc.quickstart.ServiceDependency$A) mode ACTIVE state UP (dependencies: C, B)
Service "B" (class org.jboss.msc.quickstart.ServiceDependency$B) mode ACTIVE state UP
Service "C" (class org.jboss.msc.quickstart.ServiceDependency$C) mode ACTIVE state UP
3 services displayed
~~~		

我们可以看到 Service 的 dependencies 是 B 和 C。
