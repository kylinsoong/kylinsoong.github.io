---
layout: blog
title:  "Java 多线程 - 基本概念"
date:   2016-07-10 15:10:00
categories: java
permalink: /java-lock-concepts
author: Kylin Soong
duoshuoid: ksoong2015071002
excerpt: Java 并发编程基本概念
---

* Table of contents
{:toc}

## 竞争条件(Race Condition)

### 定义

Java 多线程由于不恰当的执行时序导致不正确的/不符合预期的/不可靠的执行结果称之为竞争条件(Race Condition)。

### 示例

#### 示例-1: 非原子操作产生竞争条件

~~~
public class UnsafeCountingFactorizer extends GenericServlet implements Servlet {
    private long count = 0;

    public long getCount() {
        return count;
    }

    public void service(ServletRequest req, ServletResponse resp) {
        ++count;
    }
}
~~~

`++count` 是一个非原子的操作，它包括三个独立的操作:

1. 读取 count 的值
2. 将值加1
3. 将计算结果写入 count

这三个操作是一个 `读取 -> 修改 -> 写入` 的操作序列，并且其结果状态依赖于之前的状态。这样当多线程访问时可能回丢失一些更新操作，产生竞争条件。

#### 示例-2: 延迟初始化中的竞争条件

~~~
public class LazyInitRace {
    private ExpensiveObject instance = null;

    public ExpensiveObject getInstance() {
        if (instance == null)
            instance = new ExpensiveObject();
        return instance;
    }
}
~~~

假定线程 A 和线程 B 同时调运 `getInstance()`，

* A 看到 instance 为空，创建一个新的 ExpensiveObject
* B 同样需要判断 instance 是否为空，此时 instance 是否为空取决于不可预测的时序，如果 B 检测到 instance 为空，那么两个线程的调运可能会得到不同的结果

## 内置锁

~~~
public class LockExample {
    
    public static void foo() {
        synchronized(LockExample.class){         
        }
    }
    
    public void zoo() {
        synchronized(this) {
        }
    }
}
~~~

* 每个 Java 对象都可以作为一个实现同步的锁，这个锁被称为内置锁或监视锁
* Java 内置锁相当于一种互斥体，最多只有一个线程能持有这个锁

### 内置锁重入

~~~
public class LockExample {
    
    public void foo() {
        synchronized(this){   
            zoo();
        }
    }
    
    public void zoo() {
        synchronized(this) {
            System.out.println("zoo");
        }
    }
}
~~~

* synchronized 代码块可以获取 Java 对象的内置锁，重入指当一个线程访问 synchronized 代码块获取到对象的内置锁，可以再次获取该对象的内置锁。
* 重入提高了并发编程的灵活性

## 显示锁

![Lock]({{ site.baseurl }}/assets/blog/java-concurrency-lock.png)

### 定义

* Java 5 以后在处理多线程访问共享对象时除了原有的 `synchronized`, `volatile` 机制外，引入了一种新的机制 Lock/ReentrantLock。与之前内置锁机制相比，所有加锁/接锁机制都是显示的，即通过 `java.util.concurrent.locks.Lock` 定义的方法来实施，所以我们称 Java 5 引入的新机制为**显示锁**
* ReentrantLock 并不是一种内置锁的替换方法，而是对其的补充。ReentrantLock 可以作为一种更高级的工具，它提供了一些内置锁不具有的功能: 可定时的，可轮询的与可中断的锁获取操作，公平队列，以及非块结构的锁

### 显示锁的使用形式

~~~
 Lock l = ...;
 l.lock();
 try {
   // access the resource protected by this lock
 } finally {
   l.unlock();
 }
~~~ 

> 显示锁必需在 try-finally 代码块中使用，且必需在 finally 中释放.

### 显示锁的特性

#### 轮询锁

可轮询的获取锁是由 `boolean tryLock()` 方法实现的，如果返回为 true，则表示获取到了锁，一个典型的使用方式

~~~
 Lock lock = ...;
 if (lock.tryLock()) {
   try {
     // manipulate protected state
   } finally {
     lock.unlock();
   }
 } else {
   // perform alternative actions
 }
~~~

#### 定时锁

可定时的获取锁是由 `boolean tryLock(long time, TimeUnit unit)` 方法来实现的，如果一定时间获取不到锁返回，一个典型的使用示例

~~~
 Lock lock = ...;
 long nanosTime = ...;
 if (lock.tryLock(nanosTime, NANOSECONDS)) {
   try {
     // manipulate protected state
   } finally {
     lock.unlock();
   }
 } else {
   // perform alternative actions
 }
~~~

#### 可中断的获取锁

可中断的获取锁是由 `lockInterruptibly()` 方法实现的，该方法能够在获取锁的同时保持对线程中断的响应，一个典型的使用方式

~~~
 Lock lock = ...;
 lock.lockInterruptibly()
 try {
     // manipulate protected state
 } finally {
     lock.unlock();
 }
~~~

### 读写锁

* 读写锁是对 ReentrantLock 的补充，ReentrantLock 是一种标准的互斥锁，每次只能有一个线程持有 ReentrantLock，多线程中互斥锁是一种比较强硬的加锁规则，在一定程度限制了并发性。
* 如之前类图中 ReadWriteLock 接口暴露了两个 Lock 对象，其中一个用于读操作，另一个用于写操作。当需要读操作时获取读取锁，当需要写操作时获取写操作锁。
* 读写锁实现的加锁策略允许多个读操作同时进行，但每次只允许一个写操作。

> 读写锁允许多个线程并发地访问被保护的对象，当访问以读取操作为主时，它能提高程序的可伸缩性.

#### 读写锁实现一个 ReadWriteMap 示例

~~~
public class ReadWriteMap<K, V> {
    
    private final Map<K, V> map;
    private final ReadWriteLock lock = new ReentrantReadWriteLock();
    private final Lock r = lock.readLock();
    private final Lock w = lock.writeLock();
    
    public ReadWriteMap(Map<K, V> map) {
        this.map = map;
    }
    
    public V put(K key, V value) {
        w.lock();
        try {
            return this.map.put(key, value);
        } finally {
            w.unlock();
        }
    }
    
    public V get(Object key) {
        r.lock();
        try {
            return this.map.get(key);
        } finally {
            r.unlock();
        }
    }
}
~~~
