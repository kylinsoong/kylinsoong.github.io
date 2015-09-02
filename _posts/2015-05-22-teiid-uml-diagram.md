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

### org.teiid.query.optimizer.capabilities.CapabilitiesFinder

![CapabilitiesFinder]({{ site.baseurl }}/assets/blog/teiid-capabilitiesfinder.png)

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
