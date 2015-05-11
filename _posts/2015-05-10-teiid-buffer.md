---
layout: blog
title:  "Understanding Teiid BufferManager"
date:   2015-05-10 17:00:00
categories: teiid
permalink: /teiid-buffer
author: Kylin Soong
duoshuoid: ksoong2015051001
excerpt: How Teiid BufferManager running and processing...
---

As below figure, the Key Interface of Teiid BufferManager is `BufferManager`, it extends of interface `StorageManager` and `TupleBufferCache`.

![BufferManager UML]({{ site.baseurl }}/assets/blog/teiid-buffer.png)

The buffer manager controls how memory is used and how data flows through the system. It uses `StorageManager` to retrieve data, store data, and transfer data. The buffer manager has algorithms that tell it when and how to store data. The buffer manager should also be aware of memory management issues.

## TupleSource and TupleBuffer

As the depiction of Key Interface diagram, there are several methods related with TupleSource and TupleBuffer, like 

* createTupleBuffer(List elements, String groupName, TupleSourceType tupleSourceType)
* getTupleBuffer(String id)

In this section we will look it more.

A `TupleSource` is a cursored source of tuples. The implementation will likely be closely bound to a `BufferManager`, below figure showing TupleSource implementation in Teiid:

![BufferManager UML]({{ site.baseurl }}/assets/blog/teiid-tuplesource.png) 

An usage example of TupleSource and TupleBuffer

~~~
ElementSymbol x = new ElementSymbol("x");
x.setType(DataTypeManager.DefaultDataClasses.INTEGER);
List<ElementSymbol> schema = Arrays.asList(x);

BufferManager bm = new BufferManagerImpl();
TupleBuffer tb = bm.createTupleBuffer(schema, "x", TupleSourceType.PROCESSOR)
tb.addTuple(Arrays.asList(1, 2, 3));
tb.addTuple(Arrays.asList(2, 3, 4));
TupleBufferTupleSource tupleSource = tb.createIndexedTupleSource();
tupleSource.setReverse(true);
		
while(tupleSource.hasNext()) {
	int index = tupleSource.getCurrentIndex();
	List<?> source = tupleSource.nextTuple();
	System.out.println(index + ": " + source);
}
		
tupleSource.closeSource();
~~~

Run above example code will output like

~~~
2: [2, 3, 4]
1: [1, 2, 3]
~~~

## STree

The STree is a Self balancing Search Tree. More details from STree please refer to [Wikipedia](http://en.wikipedia.org/wiki/Self-balancing_binary_search_tree). An example of STree usage in Teiid BufferManager:

~~~
BufferManagerImpl bm = new BufferManagerImpl();
STree stree = bm.createSTree(elements, "1", 1);
stree.insert(Arrays.asList(1), InsertMode.NEW, logSize);
TupleBrowser tb = new TupleBrowser(stree, new CollectionTupleSource(Collections.singletonList(Arrays.asList(i)).iterator()), true);
tb.nextTuple();
~~~
