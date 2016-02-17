---
layout: blog
title:  "Teiid Code Analysis - UML Diagrams"
date:   2015-05-22 21:20:00
categories: teiid
permalink: /teiid-uml-diagram
author: Kylin Soong
duoshuoid: ksoong2015052201
excerpt: Teiid UML Diagrams Contains a series UML diagrams
---

* Table of contents
{:toc}

## Client

### org.teiid.client.DQP

![UML of DQP]({{ site.baseurl }}/assets/blog/teiid-uml-dqp.png)

* DQP is the client core interface, client own a DQP Proxy to interact with Teiid Server

### org.teiid.client.security.ILogon

![UML of ILogon]({{ site.baseurl }}/assets/blog/teiid-uml-ilogon.png)

* ILogon is the interface for Client generoc logon

### org.teiid.net.socket.ObjectChannel

![UML of ObjectChannel]({{ site.baseurl }}/assets/blog/teiid-uml-objectChannel.png)

* ObjectChannel is the key interface for socket write and read, it has 2 implementation
* OioObjectChannel is client implementation for socket read and write, which it wrapped a Socket client
* ObjectChannelImpl is the server implementation for socket read and write, which it wrapped a Netty Server

### org.teiid.net.socket.ServerConnection

![Teiid Client Socket Connection]({{ site.baseurl }}/assets/blog/teiid-net-connection.png)

* SocketServerConnection - Represents a client connection that maintains session state and allows for service fail over. Implements a sticky random selection policy.

### org.teiid.jdbc.ConnectionProfile

![Teiid Connection profile]({{ site.baseurl }}/assets/blog/teiid-connection-profile.png)

## Transport

### org.teiid.transport.ClientServiceRegistry

![Teiid Client Registry]({{ site.baseurl }}/assets/blog/teiid-client-registry.png)

## API

### org.teiid.metadata.AbstractMetadataRecord

![Teiid MetaData API Hierarchy]({{ site.baseurl }}/assets/blog/teiid-metadata.png)

**Example - Schema**

~~~java
MetadataStore metadataStore = new MetadataStore();
Schema schema = new Schema();
schema.setName("name");
metadataStore.addSchema(schema);
~~~

> NOTE: A Schema mainly contain Table, Procedure, FunctionMethod.

**Example - Table**

~~~java
Table table = new Table();
table.setName("name");
table.setSupportsUpdate(true);
table.setTableType(org.teiid.metadata.Table.Type.Table);
schema.addTable(table);
~~~

**Example - Column**

~~~java
Table table = new Table();
...        
Column column = new Column();
column.setName("name");
column.setRuntimeType(DataTypeManager.DefaultDataTypes.STRING);
column.setSearchType(SearchType.Searchable); 
column.setNullType(NullType.Nullable);
column.setPosition(1);
column.setUpdatable(true);
column.setLength(100);
table.addColumn(column);
~~~

### org.teiid.metadata.MetadataRepository<F,C>

![Teiid MetaData API Hierarchy]({{ site.baseurl }}/assets/blog/teiid-metadatarepo.png)

### org.teiid.query.metadata.CompositeMetadataStore

![org.teiid.query.metadata.CompositeMetadataStore]({{ site.baseurl }}/assets/blog/teiid-uml-MetadataStore.png)

* MetadataStore is a sample holder for metadata, which mainly contain Schemas(`org.teiid.metadata.Schema`) and DataTypes(`org.teiid.metadata.Datatype`).
* CompositeMetadataStore add function of merge MetadataStore together.

### Teiid Language API

Refer to [link](http://ksoong.org/teiid-language-api/)

## Engine

### Teiid Query Sql API

Refer to [link](http://ksoong.org/teiid-query-sql-api/)

### org.teiid.dqp.internal.process.RequestWorkItem

![RequestWorkItem]({{ site.baseurl }}/assets/blog/teiid-requestWorkItem.png)

* RequestWorkItem - Compiles results and other information for the client.  There is quite a bit of logic surrounding forming batches to prevent buffer growth, send multiple batches at a time, partial batches, etc.  There is also special handling for the update count case, which needs to read the entire result before sending it back to the client.
* AbstractWorkItem - Represents a task that performs work that may take more than one processing pass to complete. During processing the WorkItem may receive events asynchronously through the moreWork method.

### org.teiid.dqp.internal.process.Request

![Request UML]({{ site.baseurl }}/assets/blog/teiid-dqp-process-request.png)

### org.teiid.query.util.CommandContext

![org.teiid.query.util.CommandContext]({{ site.baseurl }}/assets/blog/teiid-uml-commandcontext.png)

* CommandContext defines the context that a command is processing in.  For example, this defines who is processing the command and why. Also, this class (or subclasses) provide a means to pass context-specific information between users of the query processor framework.

### org.teiid.query.optimizer.relational.OptimizerRule

![OptimizerRule]({{ site.baseurl }}/assets/blog/teiid-uml-OptimizerRule.png)

### org.teiid.dqp.internal.process.ThreadReuseExecutor

![ThreadReuseExecutor]({{ site.baseurl }}/assets/blog/teiid-threadreuseexecutor.png)

### org.teiid.query.metadata.QueryMetadataInterface

![QueryMetadataInterface]({{ site.baseurl }}/assets/blog/teiid-querymetadatainterface.png)

* QueryMetadataInterface interface defines the way that query components access metadata. Any user of a query component will need to implement this interface. Many  of these methods take or return things of type "Object". Typically, these objects represent a metadata-implementation-specific metadata ID. The interface define several methods:

~~~
Object getElementID(String elementName)throws TeiidComponentException, QueryMetadataException;
Object getGroupID(String groupName)throws TeiidComponentException, QueryMetadataException;
Object getModelID(String modelName)throws TeiidComponentException, QueryMetadataException;
Collection getGroupsForPartialName(String partialGroupName)throws TeiidComponentException, QueryMetadataException;
Object getModelID(Object groupOrElementID)throws TeiidComponentException, QueryMetadataException;
String getFullName(Object metadataID)throws TeiidComponentException, QueryMetadataException;
String getName(Object metadataID) throws TeiidComponentException, QueryMetadataException;
List getElementIDsInGroupID(Object groupID)throws TeiidComponentException, QueryMetadataException;
Object getGroupIDForElementID(Object elementID)throws TeiidComponentException, QueryMetadataException;
...
~~~

### org.teiid.query.optimizer.capabilities.CapabilitiesFinder

![CapabilitiesFinder]({{ site.baseurl }}/assets/blog/teiid-capabilitiesfinder.png)

The CapabilitiesFinder describes how to find connector capabilities.

### org.teiid.query.resolver.CommandResolver

![CommandResolver]({{ site.baseurl }}/assets/blog/teiid-commandresolver.png)

### org.teiid.query.optimizer.CommandPlanner

![CommandPlanner]({{ site.baseurl }}/assets/blog/teiid-CommandPlanner.png)

### org.teiid.query.processor.ProcessorPlan

![processPlan]({{ site.baseurl }}/assets/blog/teiid-uml-processplan.png)

* ProcessorPlan - This class represents a processor plan. It is generic in that it abstracts the interface to the plan by the processor, meaning that the actual implementation of the plan or the types of processing done by the plan is not important to the processor. 

### org.teiid.query.processor.ProcessorDataManager

![ProcessorDataManager]({{ site.baseurl }}/assets/blog/teiid-processordatamanager.png)

* TempTableDataManager - A proxy ProcessorDataManager used to handle temporary tables. This isn't handled as a connector because of the temporary metadata and  the create/drop handling (which doesn't have push down support).
* DataTierManagerImpl - A full ProcessorDataManager implementation that controls access to ConnectorManager and handles system queries.

### org.teiid.query.processor.relational.AccessNode

![AccessNode]({{ site.baseurl }}/assets/blog/teiid-uml-AccessNode.png)

### org.teiid.dqp.internal.datamgr.ConnectorWork

![ConnectorWork]({{ site.baseurl }}/assets/blog/teiid-connectorwork.png)

* ConnectorWork - Represents a connector execution in batched form. 
