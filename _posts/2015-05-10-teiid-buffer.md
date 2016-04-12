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

* Table of contents
{:toc}

As below figure, the Key Interface of Teiid BufferManager is `BufferManager`, it extends of interface `StorageManager` and `TupleBufferCache`.

![BufferManager UML]({{ site.baseurl }}/assets/blog/teiid-buffer.png)

The buffer manager controls how memory is used and how data flows through the system. It uses `StorageManager` to retrieve data, store data, and transfer data. The buffer manager has algorithms that tell it when and how to store data. The buffer manager should also be aware of memory management issues.

## Tuple, TupleBatch, TupleSource and TupleBuffer

* A `Tuple` in Teiid is equivalent to a list data structure, `TupleBuffer` has the 'addTuple()' method, that means add a list data. The data type in list be defined with ElementSymbol list, we will show this in example in example section.

* A `TupleBatch` in Teiid is a list of `Tuple`, it's structure like

~~~
List<List<?>> tuples;
~~~

`TupleBuffer` also has `addTupleBatch()` method, it used to add a list of `Tuple`, we will show this in example section.

* A `TupleSource` is a cursored source of tuples. The implementation will likely be closely bound to a `BufferManager`, below figure showing TupleSource implementation in Teiid:

![TupleSource]({{ site.baseurl }}/assets/blog/teiid-tuplesource.png) 

* A `TupleBuffer` is a interactive interface for BufferManager, as the depiction of BufferManager UML diagram, there are several methods related with TupleBuffer, like

~~~
TupleBuffer createTupleBuffer(List elements, String groupName, TupleSourceType tupleSourceType) throws TeiidComponentException;
TupleBuffer getTupleBuffer(String id);
~~~

A typical usage of TupleBuffer is like: 

* Create TupleBuffer
* Add Tuple or TupleBatch to TupleBuffer
* Create TupleSource via TupleBuffer
* Iterator Tuple data in TupleSource

### Example.1 TupleBuffer with Tuple and TupleSource

Assuming `PRODUCTView` under `Test` model, the create `PRODUCTView` SQL like: 

~~~
CREATE VIEW PRODUCTView (
    product_id integer, 
    symbol string
) AS SELECT p.product_id, p.symbol FROM PRODUCT AS p;
~~~

`PRODUCTView` has 6 rows data as below figure:

![Tuple Example]({{ site.baseurl }}/assets/blog/teiid-buffer-example.png) 

The example below show how use TupleBuffer add Tuple and iterator data via TupleSource. 

~~~
BufferManager bm = BufferManagerFactory.getStandaloneBufferManager();
List<ElementSymbol> elements = new ArrayList<>();
ElementSymbol id = new ElementSymbol("Test.PRODUCTView.product_id");
id.setType(DataTypeManager.DefaultDataClasses.INTEGER);
ElementSymbol symbol = new ElementSymbol("Test.PRODUCTView.symbol");
symbol.setType(DataTypeManager.DefaultDataClasses.STRING);
elements.add(id);
elements.add(symbol);
		
TupleBuffer buffer = bm.createTupleBuffer(elements, "ConnectionId", TupleSourceType.PROCESSOR);
buffer.setForwardOnly(false);
buffer.addTuple(Arrays.asList(100, "IBM"));
buffer.addTuple(Arrays.asList(101, "DELL"));
buffer.addTuple(Arrays.asList(102, "HPQ"));
buffer.addTuple(Arrays.asList(103, "GE"));
buffer.addTuple(Arrays.asList(104, "SAP"));
buffer.addTuple(Arrays.asList(105, "TM"));
		
TupleBufferTupleSource tupleSource = buffer.createIndexedTupleSource();
tupleSource.setReverse(true);	
while(tupleSource.hasNext()) {
    System.out.println(tupleSource.nextTuple());
}
tupleSource.closeSource();
~~~

Run above code will output

~~~
[105, TM]
[104, SAP]
[103, GE]
[102, HPQ]
[101, DELL]
[100, IBM]
~~~

### Example.2 TupleBuffer with TupleBatch and TupleSource

The same as [Example.1 TupleBuffer with Tuple and TupleSource](#Example.1 TupleBuffer with Tuple and TupleSource) scenarios, this example show how use TupleBuffer add TupleBatch and iterator data via TupleSource.

~~~
BufferManager bm = BufferManagerFactory.getStandaloneBufferManager();
List<ElementSymbol> elements = new ArrayList<>();
ElementSymbol id = new ElementSymbol("Test.PRODUCTView.product_id");
id.setType(DataTypeManager.DefaultDataClasses.INTEGER);
ElementSymbol symbol = new ElementSymbol("Test.PRODUCTView.symbol");
symbol.setType(DataTypeManager.DefaultDataClasses.STRING);
elements.add(id);
elements.add(symbol);
		
TupleBuffer buffer = bm.createTupleBuffer(elements, "ConnectionId", TupleSourceType.PROCESSOR);
buffer.setForwardOnly(false);
TupleBatch batch = new TupleBatch(1, Arrays.asList(Arrays.asList(100, "IBM"), Arrays.asList(101, "DELL"), Arrays.asList(102, "HPQ"), Arrays.asList(103, "GE"), Arrays.asList(104, "SAP"), Arrays.asList(105, "TM")));
buffer.addTupleBatch(batch, true);

TupleBufferTupleSource tupleSource = buffer.createIndexedTupleSource();
tupleSource.setReverse(true);
while(tupleSource.hasNext()) {
    System.out.println(tupleSource.nextTuple());
}
tupleSource.closeSource();
~~~

Run above code will output the same result as Example.1.

### Example.3 TupleBatch with Tuple

The same as [Example.1 TupleBuffer with Tuple and TupleSource](#Example.1 TupleBuffer with Tuple and TupleSource) scenarios, This example will create a TupleBatch, set the TupleBatch's attributes.

~~~
TupleBatch batch = new TupleBatch(1, Arrays.asList(Arrays.asList(100, "IBM"), Arrays.asList(101, "DELL"), Arrays.asList(102, "HPQ")));
batch.setTerminationFlag(true);
long sourceRow = 1;
while (true){
    if(batch.getRowCount() > 0 && sourceRow <= batch.getEndRow()){
        List<?> tuple = batch.getTuple(sourceRow);
        sourceRow++ ;
        System.out.println(tuple);
    }
    if(sourceRow > batch.getEndRow()) {
        break;
    }
}  
~~~

Run above code will output

~~~
[100, IBM]
[101, DELL]
[102, HPQ]
1
3
~~~

## STree

The STree is a Self balancing Search Tree. More details from STree please refer to [Wikipedia](http://en.wikipedia.org/wiki/Self-balancing_binary_search_tree). 

### Example.1 STree with TupleBatch and Tuples

The Data Structure same as [Example.1 TupleBuffer with Tuple and TupleSource](#Example.1 TupleBuffer with Tuple and TupleSource)'s scenarios, this example show how STree insert. 

~~~
BufferManager bm = BufferManagerFactory.getStandaloneBufferManager();
List<ElementSymbol> columns = new ArrayList<>();
ElementSymbol id = new ElementSymbol("Test.PRODUCTView.product_id");
id.setType(DataTypeManager.DefaultDataClasses.INTEGER);
ElementSymbol symbol = new ElementSymbol("Test.PRODUCTView.symbol");
symbol.setType(DataTypeManager.DefaultDataClasses.STRING);
columns.add(id);
columns.add(symbol);
STree tree = bm.createSTree(columns, "sessionID", 1);
        
TupleBatch batch = new TupleBatch(1, Arrays.asList(Arrays.asList(100, "IBM"), Arrays.asList(101, "DELL"), Arrays.asList(102, "HPQ")));
batch.setTerminationFlag(true);
long sourceRow = 1;
while (true){
    if(batch.getRowCount() > 0 && sourceRow <= batch.getEndRow()){
        List<?> tuple = batch.getTuple(sourceRow);
        sourceRow++ ;
        tree.insert(tuple, InsertMode.NEW, -1);
    }
    if(sourceRow > batch.getEndRow()) {
        break;
    }
}
tree.setBatchInsert(false); 
tree.compact();
System.out.println(tree.getRowCount());
~~~

Run above code will output

~~~
3
~~~

## BatchManager

BatchManager acts as a combination serializer/cachemanager. It also related with a TupleBuffer.

![BatchManager]({{ site.baseurl }}/assets/blog/teiid-buffer-batchManager.png)

## LRFU Eviction Queue

Teiid BufferManager use LRFU Eviction Queue in Cache Eviction, which LRFU means **Least Recently Used (LRU)** and **Least-Frequently Used (LFU)**, both of them are common Cache algorithms, more details from [Wikipedia](http://en.wikipedia.org/wiki/Cache_algorithms).

An usage example of LRFU Eviction Queue:

~~~
LrfuEvictionQueue<CacheEntry> queue = new LrfuEvictionQueue<CacheEntry>(new AtomicLong());
queue.add(new CacheEntry(1000L));
queue.touch(new CacheEntry(1000L));
queue.remove(new CacheEntry(1000L));
~~~

## StorageManager

Excepting BufferManager implementing StorageManager, there are some others implemeentation:

![BufferManager UML]({{ site.baseurl }}/assets/blog/teiid-buffer-storemanager.png)

From left to right:

* **BufferFrontedFileStoreCache** - Implements storage against a FileStore abstraction using a fronting memory buffer with a filesystem paradigm. All objects must go through the memory (typically off-heap) buffer so that they can be put into their appropriately sized storage bucket. 
* **MemoryStorageManager**
* **SplittableStorageManager** - A storage manager that combines smaller files into a larger logical file. The buffer methods assume that buffers cannot go beyond single file boundaries.
* **FileStorageManager** - Implements file storage that automatically splits large files and limits the number of open files.
* **EncryptedStorageManager** - Implements a block AES cipher over a regular filestore. 

Corresponding to above 5 StorageManager implementation, StorageManager interface also have a `createFileStore()` method which return a FileStore, there also are FileStore implementation as below:

![BufferManager UML]({{ site.baseurl }}/assets/blog/teiid-filestore.png)

NOTE: BufferManager's default implementation use SplittableFileStore.
 
## BufferManager usage cases

BufferManager be used in DQPCore as below:

* org.teiid.dqp.internal.process.Request's initialize

~~~
public ResultsFuture<ResultsMessage> executeRequest(long reqID,RequestMessage requestMsg) throws TeiidProcessingException{
    Request request = null;
    ...
    request.initialize(requestMsg, bufferManager,dataTierMgr, transactionService, state.sessionTables, workContext, this.prepPlanCache);
}
~~~

* org.teiid.dqp.internal.process.DataTierManagerImpl's constructor

~~~
public void start(DQPConfiguration theConfig){
    ...
    DataTierManagerImpl processorDataManager = new DataTierManagerImpl(this, this.bufferManager, this.config.isDetectingChangeEvents());
    ...
}
~~~

* org.teiid.query.tempdata.TempTableDataManager's constructor

~~~
public void start(DQPConfiguration theConfig){
    ...
    dataTierMgr = new TempTableDataManager(processorDataManager, this.bufferManager, this.rsCache);
    ...
}
~~~ 
