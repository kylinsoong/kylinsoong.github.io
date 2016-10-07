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

## 重入

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
