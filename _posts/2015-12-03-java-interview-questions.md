---
layout: blog
title:  "Java Interview Questions and Answers"
date:   2015-12-03 19:30:00
categories: java
permalink: /java-interview-questions
author: Kylin Soong
duoshuoid: ksoong2015120301
---

* Table of contents
{:toc}

## Java Multithreading

### What is atomic operation? What are atomic classes in Java Concurrency API?

Atomic operations are performed in a single unit of task without interference from other operations. Atomic operations are necessity in multi-threaded environment to avoid data inconsistency.

## Most Frequently Asked 

### Which two method you need to implement for key Object in HashMap ?

In order to use any object as Key in HashMap, it must implements `equals` and `hashcode` method in Java.

### How Hash Map Works In Java Or How Get() Method Works Internally

TODO--

### What is immutable object? Can you write immutable object?

Immutable classes are Java classes whose objects can not be modified once created. Any modification in Immutable object result in new object. For example is String is immutable in Java. Mostly Immutable are also final in Java, in order to prevent sub class from overriding methods in Java which can compromise Immutability. You can achieve same functionality by making member as non final but private and not modifying them except in constructor.

### What is the difference between creating String as new() and literal?

When we create string with new() Operator, it’s created in heap and not added into string pool while String created using literal are created in String pool itself which exists in PermGen area of heap.

### What is difference between StringBuffer and StringBuilder in Java ?

Stringbuffer methods are synchronized while StringBuilder is non synchronized.

### Write code to find the First non repeated character in the String  ?


