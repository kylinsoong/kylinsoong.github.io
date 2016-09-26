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

## ListNode

### reverse ListNode

The ListNode have 5 nodes with the order

~~~
1, 2, 3, 4, 5
~~~

now need reverse the order to 

~~~
5, 4, 3, 2, 1
~~~

**ListNode**

~~~
public class ListNode {
    Integer value;
    ListNode next;
}
~~~

**reverse(ListNode head)**

~~~
public ListNode reverse(ListNode head) {
    ListNode prev = null;
    ListNode node = null;
    ListNode current = head;
    while(current != null){
        ListNode next = current.next;
        if(next == null){
            node = current;
        }
        current.next = prev;
        prev = current;
        current = next;
    }
    return node;
}
~~~

### reverse sub ListNode

Assuming the ListNode have 5 nodes with the order

~~~
1, 2, 3, 4, 5
~~~

now need reverse sub n nodes, eg, if n is 2, the reverse result like

~~~
2, 1, 4, 3, 5
~~~

if the n is 3, the reverse result like

~~~
3, 2, 1, 4, 5
~~~

**ListNode**

~~~
public class ListNode {
    Integer value;
    ListNode next;
}
~~~

**reverse(int n, ListNode head)**

~~~

~~~

### The last n nodes

The ListNode have 5 nodes with the order

~~~
1, 2, 3, 4, 5
~~~

now need find the the last n nodes, eg, n = 3, the last 3 should be

~~~
3, 4, 5
~~~

**ListNode**

~~~
public class ListNode {
    Integer value;
    ListNode next;
}
~~~

**partition(ListNode head, int n)**

~~~
public ListNode partition(ListNode head, int n){
    if(head == null||n <= 0){
        return null;
    }
    ListNode first = head;
    ListNode second = null;
    for(int i = 0;i < n-1;i++){
        if(first.next != null){
            first = first.next;
        }else{
           return null;
        }
    }
    second = head;
    while(first.next != null){
        first = first.next;
        second = second.next;
    }
    return second;
}
~~~



