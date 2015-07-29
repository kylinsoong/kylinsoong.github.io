---
layout: blog
title:  "Teiid Code Analysis - Sequence Diagrams"
date:   2015-05-20 21:20:00
categories: teiid
permalink: /teiid-s-diagram
author: Kylin Soong
duoshuoid: ksoong2015052002
excerpt: Teiid Sequence Diagrams Contains a series Sequence diagrams
---

## Teiid Client

### How a connection execute the query

Assuming view 'Marketdata' existed in Teiid VDB, a JDBC client execute query like:

~~~
...
Statement stmt = conn.createStatement();
stmt.executeQuery("SELECT * FROM Marketdata");
~~~

the below sequence diagram shows how query sql `SELECT * FROM Marketdata` be sent to Teiid Server

![teiid-execute-query]({{ site.baseurl }}/assets/blog/teiid-execute-query.png)

* StatementImpl **executeQuery** receive the query sql `SELECT * FROM Marketdata`
* StatementImpl assemble a `org.teiid.client.RequestMessage` base query sql, then invoke DQP Proxy's **executeRequest**
* RemoteInvocationHandler's **invoke** method be invoked
* RemoteInvocationHandler assemble a `org.teiid.net.socket.Message` base on passed `org.teiid.client.RequestMessage`, then SocketServerInstanceImpl's **send** method be invoked
* OioObjectChannel's **write** methd be invoked
* ObjectOutputStream which come from socket **writeObject** `org.teiid.net.socket.Message`

### How Teiid Server handle query request

![teiid-server-hanlde-request]({{ site.baseurl }}/assets/blog/teiid-server-hanlde-request.png)

* SSLAwareChannelHandler

While Teiid Server Started, it will create a SocketListener which listen for new connection requests and create a SocketClientConnection for each connection request.

The SocketListener bootstrap netty server worker threads with port number 31000, SSLAwareChannelHandler is the handler used by netty server side, it's `messageReceived()` can be thought as teiid server side entry point. Once a client request in, this method be first invoked. 

* SocketClientInstance

Sockets implementation of the communication framework class representing the server's view of a client connection. Implements the server-side of the sockets messaging protocol. The client side of the protocol is implemented in SocketServerInstance.

It's `processMessagePacket()` method be invoked for handling income request message.

* DQPWorkContext & ServerWorkItem

ServerWorkItem is a runnable class, it encapulates income request message in it's constructor:

~~~
    public ServerWorkItem(ClientInstance socketClientInstance, Serializable messageKey, Message message, ClientServiceRegistryImpl server) {
                this.socketClientInstance = socketClientInstance;
                this.messageKey = messageKey;
                this.message = message;
                this.csr = server;
        }
~~~

DQPWorkContext is a filed of SocketClientInstance, DQPWorkContext's `runInContext()` method be invoked, the constructed ServerWorkItem passed as a argument. Then ServerWorkItem's `run()` method be invoked.

## Teiid Engine

### DQPCore execute request

DQPCore implements client interface DQP, it has defined a 'executeRequest' method:

~~~
public ResultsFuture<ResultsMessage> executeRequest(long reqID,RequestMessage requestMsg) throws TeiidProcessingException;
~~~

what 'executeRequest' method is a Entry Point for client request, it has parameter `RequestMessage` which contains client query command, and the method return `ResultsMessage` which contains the tuple results. 

The below sequence diagram shows how DQPCore's 'executeRequest' method run and return a `ResultsMessage`:

![teiid connector logic]({{ site.baseurl }}/assets/blog/teiid-dqp-executerequest.png)

* 1 StatementImpl invoke DQPCore's `executeRequest()` method with **RequestMessage** as parameter
* 2 **Request** and **RequestWorkItem** initialize
* 3 - 5 [http://ksoong.org/teiid-dqp/](http://ksoong.org/teiid-dqp/)
* 6 Refer to below `BatchCollector collect tuples` section

### BatchCollector collect tuples

BatchCollector collect tuples are related with BufferManager, the sequence diagram as below

![teiid batch collector]({{ site.baseurl }}/assets/blog/teiid-batchcollector-batch.png)

* 1 collectTuples first invoke QueryProcessor's nextBatch() method get the `TupleBatch`, then invoke flushBatch() method with `TupleBatch` as a parameter
* 2 If TupleBatch's row count is 0 and TupleBatch's Termination flag is NOT_TERMINATED flushBatch() method return, else invoke flushBatchDirect() method with `TupleBatch` as a parameter
* 3 Invoke TupleBuffer's addTupleBatch() method to add `TupleBatch` to TupleBuffer;
* 4 addTupleBatch() first update TupleBuffer's **rowCount** then recursively invoke addTuple() method to add each `Tuple` to TupleBuffer;
* 5 addTuple() first create a temporary ResizingArrayList, add all `Tuple` to this list, then invoke saveBatch() method
* 6 BatchManager's createManagedBatch() be invoked return a `mbatch` as Batch Id; add `mbatch` to batches TreeMap; rest temporary ResizingArrayList to null;
* 7 update BatchManagerImpl's **totalSize** with the total size of Tuples in ResizingArrayLise; update BatchManagerImpl's **rowsSampled** with ResizingArrayList's size; BufferManagerImpl's **batchAdded** getAndIncrement; Create CacheEntry and add CacheEntry's id to BufferFrontedFileStoreCache's **physicalMapping** map(BatchManagerImpl id is Key, Batch Id is Value); Invoke addMemoryEntry() method with CacheEntry as parameter; return Batch Id;
* 8 Invoke persistBatchReferences(); add CacheEntry to BufferManagerImpl's **memoryEntries** map(CacheEntry's Id is Key, CacheEntry is Value); add CacheEntry to BufferManagerImpl's **initialEvictionQueue**; update BufferManagerImpl's **activeBatchBytes**
* 9 TIDO--

### DataTierTupleSource getResults

Continue with DQPCore execute request, below sequence diagram shows how DataTierTupleSource interact with Translator layer and getResults `AtomicResultsMessage`

![teiid connector logic]({{ site.baseurl }}/assets/blog/connectorworkitem.jpg)

#### execute()

Its main function is create a translator Execution, then invoke Execution's execute() method, the completed procedure like:

* Create Data Source Connection base on JCA connector implementation
* Create translator Execution with translator ExecutionFactory
* Invoke translator Execution's execute() method

#### more()

Usually this methods be invoked after execute(), this method will invoke Execution's next() method repeatedly, return list of rows existed in data source.
