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

死锁需要两个对象，两个线程，本示例两个对象为 A 和 B，两个线程分别为 Thread 1 和 Thread 2，运行如下代码会出现线程死锁:

~~~
final Object a = new Object();
final Object b = new Object();

new Thread(new Runnable(){
	public void run() {
		Thread.currentThread().setName("Thread 1");
		synchronized(a){
			sleep(1000);
			synchronized(b){
			}
		}				
	}}).start();
		
new Thread(new Runnable(){
	public void run() {
		Thread.currentThread().setName("Thread 2");
		synchronized(b){
			sleep(1000);
			synchronized(a){
			}
		}
	}}).start();
~~~

如上，两个线程同时启动且分别尝试锁定 A B 对象的 `monitor`，如下:

* 线程 1 通过 synchronized 锁定 A 对象 `monitor`
* 线程 2 通过 synchronized 锁定 B 对象 `monitor`
* 线程 1 休眠 1000 毫秒
* 线程 2 休眠 1000 毫秒
* 线程 1 通过 synchronized 尝试锁定 B 对象 `monitor`
* 线程 2 通过 synchronized 尝试锁定 A 对象 `monitor`

由于线程 1 拥有 A 的锁等待线程 2 释放 B 的锁，而线程 2 拥有 B 的锁等待线程 1释放 A 的锁，这样造成线程 1 和 线程 2 死锁。如上代码运行会出现死锁，程序运行处于永久等待状态。Java 虚拟线程 dump 日志描述如下:

~~~
"Thread 2" #10 prio=5 os_prio=0 tid=0x00007fc7bc0f5800 nid=0xf60 waiting for monitor entry [0x00007fc7962e9000]
   java.lang.Thread.State: BLOCKED (on object monitor)
        at DeadlockExample$2.run(DeadlockExample.java:58)
        - waiting to lock <0x00000000d7f79670> (a java.lang.Object)
        - locked <0x00000000d7f79680> (a java.lang.Object)
        at java.lang.Thread.run(Thread.java:745)

   Locked ownable synchronizers:
        - None

"Thread 1" #9 prio=5 os_prio=0 tid=0x00007fc7bc0f3800 nid=0xf5f waiting for monitor entry [0x00007fc7963ea000]
   java.lang.Thread.State: BLOCKED (on object monitor)
        at DeadlockExample$1.run(DeadlockExample.java:47)
        - waiting to lock <0x00000000d7f79680> (a java.lang.Object)
        - locked <0x00000000d7f79670> (a java.lang.Object)
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

接下来，我们启动二个线程(Thread 1，Thread 2)调用 BlockingQueue 的 take() 方法:

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
		
~~~

两个个线程都处于阻塞状态，都被添加到 BlockingQueue 对象的 wait 集合中，JVM 中线程 dumo 日志如下:

~~~
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

> NOTE: 在上面 dump 中，0x00000000d7f7b4d8 被二个线程锁定过，但二个线程同样阻塞于 0x00000000d7f7b4d8

如果调有 BlockingQueue 的 put 方法，则相应的 wait 集合中的线程被唤起，被唤起的线程从 wait 集合中移除。

## Lock

java.util.concurrent.locks 包中 API 提供了多线程锁相关的实现，如下图 `Lock` 可以看作是对 `synchronization` 机制的扩展，它提供了更广泛，更灵活的锁操作机制。

锁用来控制多线程访问线程之间共享的资源，通常一个线程访问共享的资源，首先它需要获取锁，但有些锁可以允许多个线程同时访问共享的资源，如 java.util.concurrent.locks 包中 ReadWriteLock 的 ReadLock. 

![Lock]({{ site.baseurl }}/assets/blog/java-concurrency-lock.png)

#### Java DeadlockExample with Lock

使用 java.util.concurrent.locks 包中 API 来实现 Synchronization 部分 DeadLock 示例如下:

~~~
final Lock a = new ReentrantLock();
final Lock b = new ReentrantLock();
		
new Thread(new Runnable(){
	public void run() {
		Thread.currentThread().setName("Thread 1");
		a.lock();
		sleep(1000);
		b.lock();				
	}}).start();
		
new Thread(new Runnable(){
	public void run() {
		Thread.currentThread().setName("Thread 2");
		b.lock();
		sleep(1000);
		a.lock();
	}}).start();
~~~

类似 Synchronization 部分 DeadLock 示例

* Thread 1 锁定 A 的同时 Thread 2 锁定 B
* Thread 1 在拥有 A 的锁后尝试锁定 B，阻塞于等待 Thread 1 释放 A 
* Thread 2 在拥有 B 的锁后尝试锁定 A，阻塞于等待 Thread 2 释放 B

如上代码运行会出现死锁，程序运行处于永久等待状态。Java 虚拟线程 dump 日志描述如下:

~~~
"Thread 2" #10 prio=5 os_prio=0 tid=0x00007f1fbc0dd800 nid=0x134d waiting on condition [0x00007f1fac1f0000]
   java.lang.Thread.State: WAITING (parking)
        at sun.misc.Unsafe.park(Native Method)
        - parking to wait for  <0x00000000d7f7acf8> (a java.util.concurrent.locks.ReentrantLock$NonfairSync)
        at java.util.concurrent.locks.LockSupport.park(LockSupport.java:175)
        at java.util.concurrent.locks.AbstractQueuedSynchronizer.parkAndCheckInterrupt(AbstractQueuedSynchronizer.java:836)
        at java.util.concurrent.locks.AbstractQueuedSynchronizer.acquireQueued(AbstractQueuedSynchronizer.java:870)
        at java.util.concurrent.locks.AbstractQueuedSynchronizer.acquire(AbstractQueuedSynchronizer.java:1199)
        at java.util.concurrent.locks.ReentrantLock$NonfairSync.lock(ReentrantLock.java:209)
        at java.util.concurrent.locks.ReentrantLock.lock(ReentrantLock.java:285)
        at DeadlockExample$4.run(DeadlockExample.java:62)
        at java.lang.Thread.run(Thread.java:745)

   Locked ownable synchronizers:
        - <0x00000000d7f7ad28> (a java.util.concurrent.locks.ReentrantLock$NonfairSync)

"Thread 1" #9 prio=5 os_prio=0 tid=0x00007f1fbc0db800 nid=0x134c waiting on condition [0x00007f1fac2f1000]
   java.lang.Thread.State: WAITING (parking)
        at sun.misc.Unsafe.park(Native Method)
        - parking to wait for  <0x00000000d7f7ad28> (a java.util.concurrent.locks.ReentrantLock$NonfairSync)
        at java.util.concurrent.locks.LockSupport.park(LockSupport.java:175)
        at java.util.concurrent.locks.AbstractQueuedSynchronizer.parkAndCheckInterrupt(AbstractQueuedSynchronizer.java:836)
        at java.util.concurrent.locks.AbstractQueuedSynchronizer.acquireQueued(AbstractQueuedSynchronizer.java:870)
        at java.util.concurrent.locks.AbstractQueuedSynchronizer.acquire(AbstractQueuedSynchronizer.java:1199)
        at java.util.concurrent.locks.ReentrantLock$NonfairSync.lock(ReentrantLock.java:209)
        at java.util.concurrent.locks.ReentrantLock.lock(ReentrantLock.java:285)
        at DeadlockExample$3.run(DeadlockExample.java:53)
        at java.lang.Thread.run(Thread.java:745)

   Locked ownable synchronizers:
        - <0x00000000d7f7acf8> (a java.util.concurrent.locks.ReentrantLock$NonfairSync)
~~~

## Condition

如上 Lock 中 UML 图所示，Lock 定义了一个 newCondition() 方法，用来获取 Lock 相关联的 Condition 对象，

![Condition]({{ site.baseurl }}/assets/blog/java-concurrency-condition.png)

## 参考文献

* [The Java® Language Specification - Java SE 8 Edition](http://docs.oracle.com/javase/specs/jls/se8/html/jls-17.html)
