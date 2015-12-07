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

### org.teiid.transport.ClientServiceRegistry

![Teiid Client Registry]({{ site.baseurl }}/assets/blog/teiid-client-registry.png)

### org.teiid.jdbc.ConnectionProfile

![Teiid Connection profile]({{ site.baseurl }}/assets/blog/teiid-connection-profile.png)

### org.teiid.metadata.AbstractMetadataRecord

![Teiid MetaData API Hierarchy]({{ site.baseurl }}/assets/blog/teiid-metadata.png)

### org.teiid.metadata.MetadataRepository<F,C>

![Teiid MetaData API Hierarchy]({{ site.baseurl }}/assets/blog/teiid-metadatarepo.png)

### org.teiid.dqp.internal.process.RequestWorkItem

![RequestWorkItem]({{ site.baseurl }}/assets/blog/teiid-requestWorkItem.png)

* RequestWorkItem - Compiles results and other information for the client.  There is quite a bit of logic surrounding forming batches to prevent buffer growth, send multiple batches at a time, partial batches, etc.  There is also special handling for the update count case, which needs to read the entire result before sending it back to the client.
* AbstractWorkItem - Represents a task that performs work that may take more than one processing pass to complete. During processing the WorkItem may receive events asynchronously through the moreWork method.

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

### org.teiid.query.processor.ProcessorPlan

![processPlan]({{ site.baseurl }}/assets/blog/teiid-processplan.png)

* ProcessorPlan - This class represents a processor plan. It is generic in that it abstracts the interface to the plan by the processor, meaning that the actual implementation of the plan or the types of processing done by the plan is not important to the processor. 

### org.teiid.query.processor.ProcessorDataManager

![ProcessorDataManager]({{ site.baseurl }}/assets/blog/teiid-processordatamanager.png)

* TempTableDataManager - A proxy ProcessorDataManager used to handle temporary tables. This isn't handled as a connector because of the temporary metadata and  the create/drop handling (which doesn't have push down support).
* DataTierManagerImpl - A full ProcessorDataManager implementation that controls access to ConnectorManager and handles system queries.

### org.teiid.dqp.internal.datamgr.ConnectorWork

![ConnectorWork]({{ site.baseurl }}/assets/blog/teiid-connectorwork.png)

* ConnectorWork - Represents a connector execution in batched form. 
