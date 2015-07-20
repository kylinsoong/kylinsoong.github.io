---
layout: blog
title:  "Java 多线程 - Synchronization, Locks, Conditions"
date:   2015-07-20 15:30:00
categories: java
permalink: /java-lock-condition
author: Kylin Soong
duoshuoid: ksoong2015072001
excerpt: Java Concurrency, Synchronization, Lock, Condition
---

## Synchronization

Java 语言提供了很多种多线程之间通信的机制，但最基本的方式是通过 `monitors` 实现的 `synchronization` 机制。这个机制主要使用关键字是 synchronized，关于这个同步机制以及 synchronized 关键字我们可总结如下几点：

* Java 中每一个对象都关联一个 `monitor`，static 申明对应的对象是相应的 Class 对象
* Java 通过 synchronized 来获取 `monitor`，当 synchronized 的方法或代码段执行完成后释放 `monitor`
* Java 中任意线程可锁定一个 `monitor`
* Java 中同一线程可对 `monitor` 多次锁定或解锁，但在一个时间点上，当一个对象的 `monitor` 被锁定，其他线程要获取此 `monitor`  就需要等待

举例说明，如下代码段：

~~~
public class MonitorExample {  
    public synchronized void foo(){}  
    public synchronized void zoo() {}  
    public static synchronized void bar() {}      
} 
~~~

假设 MonitorExample 对象被实例化，则其关联一个 `monitor`，

* 如果线程 A 在访问 foo 且没有完成，则其他线程不能够访问 foo 或 zoo - 因为线程 A 访问 foo 时通过 synchronized 获取了 MonitorExample 对象的 `monitor`，其他线程要访问 foo 或 zoo 时，同样需要获取 MonitorExample 对象的 `monitor`，由于 foo 没有完成，所以 `monitor` 上的锁没有被释放，即其他线程访问 foo 或 zoo 需要等待锁释放
* 如果线程 A 在访问 foo 且没有完成，其他线程可以访问 bar，因为 static 方法对应的对象是 Class 对象，所以 static 方法可以访问

事实上，Java 编程中更推荐使用下面的方法，这样更能体现出 Java 中一个对象都关联一个 `monitor`

~~~
public class MonitorExample {  
    public void foo(){synchronized(this) {}}  
    public void zoo() {synchronized(this) {}}     
    public static void bar() {synchronized(Demo.class) {}}  
}  
~~~

#### Java-level deadlock 示例

本示例演示使用 synchronized 模拟 Java 中常见的死锁问题。

死锁需要两个对象，两个线程，本示例两个对象为 A 和 B:

~~~
class A {
	public void foo(B b){
		synchronized(this){
			try {
				Thread.sleep(1000);
			} catch (InterruptedException e) {
			}
			b.foo(this);
		}
	}
}

class B {
	public void foo(A a){
		synchronized(this){
			try {
				Thread.sleep(1000);
			} catch (InterruptedException e) {
			}
			a.foo(this);
		}
	}
}
~~~

对象 A 和 B 都提供一个 foo 方法用来获取 `monitor`。如果两个线程同事启动且分别访问 A 对象 foo 和 B 对象 foo 时会产生死锁，如下:

* 线程 1 访问 A 对象 foo， 锁定 A 对象 `monitor`
* 线程 2 访问 B 对象 foo， 锁定 B 对象 `monitor`
* 线程 1 休眠 1000 毫秒
* 线程 2 休眠 1000 毫秒
* 线程 1 访问 B 对象 foo 尝试获取 B 对象 `monitor`
* 线程 2 访问 A 对象 foo 尝试获取 A 对象 `monitor`

如下代码段可描述如上过程

~~~
final A a = new A();
final B b = new B();

new Thread(new Runnable(){
	public void run() {
		Thread.currentThread().setName("Thread 1");
		a.foo(b);
	}}).start();
		
new Thread(new Runnable(){
	public void run() {
		Thread.currentThread().setName("Thread 2");
		b.foo(a);
	}}).start();
~~~

如上代码运行会出现死锁，程序运行处于永久等待状态。Java 虚拟线程 dump 日志描述如下:

~~~
"Thread 1" #9 prio=5 os_prio=0 tid=0x00007f3eb80cb000 nid=0x1676 waiting for monitor entry [0x00007f3ea8ffe000]
   java.lang.Thread.State: BLOCKED (on object monitor)
	at B.foo(DeadlockExample.java:17)
	- waiting to lock <0x00000000d7f7c180> (a B)
	at A.foo(DeadlockExample.java:8)
	- locked <0x00000000d7f7a968> (a A)
	at DeadlockExample$1.run(DeadlockExample.java:35)
	at java.lang.Thread.run(Thread.java:745)

   Locked ownable synchronizers:
	- None

"Thread 2" #10 prio=5 os_prio=0 tid=0x00007f3eb80cd000 nid=0x1677 waiting for monitor entry [0x00007f3ea8efd000]
   java.lang.Thread.State: BLOCKED (on object monitor)
	at A.foo(DeadlockExample.java:5)
	- waiting to lock <0x00000000d7f7a968> (a A)
	at B.foo(DeadlockExample.java:20)
	- locked <0x00000000d7f7c180> (a B)
	at DeadlockExample$2.run(DeadlockExample.java:41)
	at java.lang.Thread.run(Thread.java:745)

   Locked ownable synchronizers:
	- None

~~~

> NOTE: Java 语言中没有提供死锁自动检测的机制，在编程中要注意 synchronized 关键字的使用，另外读写 volatile 变量或使用 java.util.concurrent 包中的类是另一种可供选择的类 Synchronization 机制

### wait, notify

Java 对象除了关联一个 `monitor` 外，还关联一个 wait 集合。一个 wait 集合可以理解为一个线程的集合。当一个对象创建时 wait 集合为空，一个线程如果调用如下方法会将其添加到 wait 集合:

~~~
wait()
wait(long timeout)
wait(long timeout, int nanos)
~~~

要移除 wait 集合中线程，wait 集合对应 Java 对象的如下方法需要被调用

~~~
notify()
notifyAll()
~~~

wait, notify 是多线程的基础：

* 一个对象的 `monitor` 被一个线程锁定后，调用该对象的 wait 方法可释放锁
* wait 和 notify 调用首先需要获取锁
* wait 阻塞一个线程，但释放当前对象的锁
* notify 随即释放 wait 集合中一个阻塞的线程

#### BlockingQueue 示例

BlockingQueue 示例用来演示多线程调有 wait, notify。

首先 BlockingQueue 代码如下，它提供两个方法 put 和 take，两个方法中分别调用 wait, notify，代码如下：

~~~  
public class BlockingQueue<T> {
	
	private Queue<T> queue = new LinkedList<T>();
	private int capacity;
	
	public BlockingQueue(int capacity) {
        this.capacity = capacity;
    }
	
	public void put(T element) throws InterruptedException {
		synchronized(this){
			while(queue.size() == capacity){
				wait();
			}
			queue.add(element);
			notify();
		}
	}
	
	public T take() throws InterruptedException{
		synchronized(this){
			while(queue.isEmpty()){
				wait();
			}
			T item = queue.remove();
			notify();
			return item;
		}
	}
}
~~~

接下来，我们启动三个线程调用 BlockingQueue:

~~~
final BlockingQueue<String> queue = new BlockingQueue<>(3);
						
new Thread(new Runnable(){
	public void run() {
		Thread.currentThread().setName("Thread 1");
		System.out.println(queue.take());
	}}).start();
		
new Thread(new Runnable(){
	public void run() {
		Thread.currentThread().setName("Thread 2");
		System.out.println(queue.take());
	}}).start();
		
new Thread(new Runnable(){
	public void run() {
		Thread.currentThread().setName("Thread 3");
		System.out.println(queue.take());
	}}).start();
~~~

三个线程都处于阻塞状态，都被添加到 BlockingQueue 对象的 wait 集合中，JVM 中线程 dumo 日志如下:

~~~
"Thread 3" #11 prio=5 os_prio=0 tid=0x00007f90040cf800 nid=0x2f6a in Object.wait() [0x00007f8fe9779000]
   java.lang.Thread.State: WAITING (on object monitor)
	at java.lang.Object.wait(Native Method)
	- waiting on <0x00000000d7f7b4d8> (a BlockingQueue)
	at java.lang.Object.wait(Object.java:502)
	at BlockingQueue.take(BlockingQueue.java:27)
	- locked <0x00000000d7f7b4d8> (a BlockingQueue)
	at WaitSetExample$3.run(WaitSetExample.java:38)
	at java.lang.Thread.run(Thread.java:745)

   Locked ownable synchronizers:
	- None

"Thread 2" #10 prio=5 os_prio=0 tid=0x00007f90040ce000 nid=0x2f69 in Object.wait() [0x00007f8fe987a000]
   java.lang.Thread.State: WAITING (on object monitor)
	at java.lang.Object.wait(Native Method)
	- waiting on <0x00000000d7f7b4d8> (a BlockingQueue)
	at java.lang.Object.wait(Object.java:502)
	at BlockingQueue.take(BlockingQueue.java:27)
	- locked <0x00000000d7f7b4d8> (a BlockingQueue)
	at WaitSetExample$2.run(WaitSetExample.java:32)
	at java.lang.Thread.run(Thread.java:745)

   Locked ownable synchronizers:
	- None

"Thread 1" #9 prio=5 os_prio=0 tid=0x00007f90040cc000 nid=0x2f68 in Object.wait() [0x00007f8fe997b000]
   java.lang.Thread.State: WAITING (on object monitor)
	at java.lang.Object.wait(Native Method)
	- waiting on <0x00000000d7f7b4d8> (a BlockingQueue)
	at java.lang.Object.wait(Object.java:502)
	at BlockingQueue.take(BlockingQueue.java:27)
	- locked <0x00000000d7f7b4d8> (a BlockingQueue)
	at WaitSetExample$1.run(WaitSetExample.java:26)
	at java.lang.Thread.run(Thread.java:745)

   Locked ownable synchronizers:
	- None
~~~

> NOTE: 在上面 dump 中，0x00000000d7f7b4d8 被三个线程锁定过，但三个线程同样阻塞于 0x00000000d7f7b4d8

如果调有 BlockingQueue 的 put 方法，则相应的 wait 集合中的线程被唤起。

## Lock 

![Lock]({{ site.baseurl }}/assets/blog/java-concurrency-lock.png)

## Condition

![Condition]({{ site.baseurl }}/assets/blog/java-concurrency-condition.png)

## 参考文献

* [The Java® Language Specification - Java SE 8 Edition](http://docs.oracle.com/javase/specs/jls/se8/html/jls-17.html)
