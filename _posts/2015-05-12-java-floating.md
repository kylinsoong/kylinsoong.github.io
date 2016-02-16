---
layout: blog
title:  "Java 中的运算符"
date:   2015-05-12 14:30:00
categories: java
permalink: /java-floating
author: Kylin Soong
duoshuoid: ksoong2015051201
excerpt: Java 运算符: <<, >>, ., |, &, ^, |=, &=, ^=
---

* Table of contents
{:toc}

### 位运算符 <<

位运算符 << 指将二进制位左移， a << b 即为 a * (2^b)，例如：

* 1 << 0   ->  1 * (2^0)  = 1           (1 字节)
* 1 << 10  ->  1 * (2^10) = 1024        (1 KB)
* 1 << 20  ->  1 * (2^20) = 1048576     (1 MB)
* 1 << 30  ->  1 * (2^30) = 1073741824  (1 GB)

### 位运算符 >>

位运算符 >> 指将二进制位右移 a >> b 即为 a / (2^b)，例如：

* 1073741824 >> 10  ->  1073741824 / (2^10) = 1048576 (GB 转化 MB)
* 1048576 >> 10     ->  1048576 / (2^10) = 1024       (MB 转化 KB)
* 1024 >> 10        ->  1024 / (2^10) =1              (KB 转化字节) 

NOTE: 一个应用实例, Teiid BufferManager 默认设定的 MaxBufferSpace 为 50 GB(50L<<30) 

### 比率运算符 .
 
比率运算 .a 即为 1 * 0.a，例如：

* .7  -> 0.7
* .83 -> 0.83

**示例**

~~~
long maxMemory = Runtime.getRuntime().maxMemory();
maxMemory = Math.max(0, maxMemory - (150 << 20)); //assume an overhead for the system stuff is 150 MB
int one_gig = 1 << 30;
long maxReserveBytes = (long)Math.max(0, (maxMemory - one_gig) * .7); /assume 70% of the memory over the first gig
~~~

### 与，或，异或运算符 &, |, ^

与运算符 &，使用场景，a = a & b, a &= b;
或运算符 |，使用场景，a = a | b, a |= b;
异或运算符 ^，使用场景，a = a ^ b, a ^= b;

**示例.1**

~~~
boolean a = false;
boolean b = true;
        
System.out.println(a & b);
System.out.println(a | b);
System.out.println(a ^ b );
a &= b;
System.out.println(a);
a |= b;
System.out.println(a);
a ^= b;
System.out.println(a);
~~~

**示例.2**

~~~
int a = 1 << 2;
int b = 1 << 3;
int c = 1 << 4;
int d = 1 << 5;
int e = 1 << 6;
int f = 1 << 7;
int g = a | b | c | d | e | f;
int h = b & g;
int i = e & g;
        
System.out.println(a);
System.out.println(b);
System.out.println(c);
System.out.println(d);
System.out.println(e);
System.out.println(f);
System.out.println(g);
System.out.println(h);
System.out.println(i);
~~~

The output:

~~~
4
8
16
32
64
128
252
8
64
~~~
