---
layout: blog
title:  "Java ThreadLocal"
date:   2015-05-18 11:00:00
categories: java
permalink: /java-threadlocal
author: Kylin Soong
duoshuoid: ksoong2015051801
excerpt: What and Why Java ThreadLocal
---

## 什么是 Java ThreadLocal

**java.lang.ThreadLocal** class provides thread-local variables. These variables differ from their normal counterparts in that each thread that accesses one (via its get() or set() method)has its own, independently initialized copy of the variable. 

Java ThreadLocal instances are typically private static fields in classes that wish to associate state with a thread (e.g., a user ID or Transaction ID).

For example, the class below generates unique identifiers local to each thread. A thread's id is assigned the first time it invokes ThreadId.get() and remains unchanged on subsequent calls.

~~~
import java.util.concurrent.atomic.AtomicInteger;

public class ThreadId {

	private static final AtomicInteger nextId = new AtomicInteger(0);
	
	private static final ThreadLocal<Integer> threadId = new ThreadLocal<Integer>(){
		public Integer get() {
			return nextId.getAndIncrement();
		}};	
	
	public static int get(){
		return threadId.get();
	}
}
~~~

Each thread holds an implicit reference to its copy of a thread-local variable as long as the thread is alive and the `ThreadLocal` instance is accessible; after a thread goes away, all of its copies of thread-local instances are subject to garbage collection (unless other references to these copies exist). 

## 为什么 Java ThreadLocal

* [http://stackoverflow.com/questions/817856/when-and-how-should-i-use-a-threadlocal-variable](http://stackoverflow.com/questions/817856/when-and-how-should-i-use-a-threadlocal-variable)
