---
layout: blog
title:  "Teiid Code Analysis"
date:   2014-11-19 18:35:00
categories: teiid
permalink: /teiid-code
author: Kylin Soong
duoshuoid: ksoong20141119
---

[Teiid](https://github.com/teiid/teiid) is the codebase for teiid project, this article will guide you how to look over the complete Teiid code.


## Dynamic Proxy

Teiid use the Dynamic Proxy quite frequently, the following are quick links:

* [org.teiid.logging.LogManager.LoggingProxy](https://github.com/teiid/teiid/blob/master/api/src/main/java/org/teiid/logging/LogManager.java)
* [org.teiid.net.socket.SocketServerConnectionFactory.ShutdownHandler](https://github.com/teiid/teiid/blob/master/client/src/main/java/org/teiid/net/socket/SocketServerConnectionFactory.java)
* [org.teiid.net.socket.SocketServerInstanceImpl.RemoteInvocationHandler](https://github.com/teiid/teiid/blob/master/client/src/main/java/org/teiid/net/socket/SocketServerInstanceImpl.java)
* [org.teiid.jdbc.XAConnectionImpl.CloseInterceptor](https://github.com/teiid/teiid/blob/master/client/src/main/java/org/teiid/jdbc/XAConnectionImpl.java)
* [org.teiid.jdbc.DataTypeTransformer](https://github.com/teiid/teiid/blob/master/client/src/main/java/org/teiid/jdbc/DataTypeTransformer.java)
* [org.teiid.core.util.MixinProxy](https://github.com/teiid/teiid/blob/master/common-core/src/main/java/org/teiid/core/util/MixinProxy.java)
* [org.teiid.transport.LocalServerConnection.getService()](https://github.com/teiid/teiid/blob/master/runtime/src/main/java/org/teiid/transport/LocalServerConnection.java)
* [org.teiid.transport.PgFrontendProtocol.PgFrontendProtocol()](https://github.com/teiid/teiid/blob/master/runtime/src/main/java/org/teiid/transport/PgFrontendProtocol.java)
* [org.teiid.transport.ODBCClientInstance.processMessage()](https://github.com/teiid/teiid/blob/master/runtime/src/main/java/org/teiid/transport/ODBCClientInstance.java)
* [org.teiid.services.AbstractEventDistributorFactoryService.start()](https://github.com/teiid/teiid/blob/master/runtime/src/main/java/org/teiid/services/AbstractEventDistributorFactoryService.java)
* [org.teiid.replication.jgroups.JGroupsObjectReplicator.ReplicatedInvocationHandler](https://github.com/teiid/teiid/blob/master/runtime/src/main/java/org/teiid/replication/jgroups/JGroupsObjectReplicator.java)
* [org.teiid.runtime.EmbeddedServer.start()](https://github.com/teiid/teiid/blob/master/runtime/src/main/java/org/teiid/runtime/EmbeddedServer.java)
* [org.teiid.dqp.internal.datamgr.ConnectorManager.ConnectorWork](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/dqp/internal/datamgr/ConnectorManager.java)
* [org.teiid.translator.jdbc.JDBCExecutionFactory.getDialect()](https://github.com/teiid/teiid/blob/master/connectors/translator-jdbc/src/main/java/org/teiid/translator/jdbc/JDBCExecutionFactory.java)

## Externalizable, Serializable

The following class are implement Externalizable:

* [org.teiid.net.socket.Message](https://github.com/teiid/teiid/blob/master/client/src/main/java/org/teiid/net/socket/Message.java)
* [org.teiid.net.socket.Handshake](https://github.com/teiid/teiid/blob/master/client/src/main/java/org/teiid/net/socket/Handshake.java)
* [org.teiid.net.socket.ServiceInvocationStruct](https://github.com/teiid/teiid/blob/master/client/src/main/java/org/teiid/net/socket/ServiceInvocationStruct.java)
* [org.teiid.client.ResultsMessage](https://github.com/teiid/teiid/blob/master/client/src/main/java/org/teiid/client/ResultsMessage.java)
* [org.teiid.client.RequestMessage](https://github.com/teiid/teiid/blob/master/client/src/main/java/org/teiid/client/RequestMessage.java)
* [org.teiid.client.xa.XidImpl](https://github.com/teiid/teiid/blob/master/client/src/main/java/org/teiid/client/xa/XidImpl.java)
* [org.teiid.client.plan.Annotation](https://github.com/teiid/teiid/blob/master/client/src/main/java/org/teiid/client/plan/Annotation.java)
* [org.teiid.client.plan.PlanNode](https://github.com/teiid/teiid/blob/master/client/src/main/java/org/teiid/client/plan/PlanNode.java)
* [org.teiid.client.metadata.MetadataResult](https://github.com/teiid/teiid/blob/master/client/src/main/java/org/teiid/client/metadata/MetadataResult.java)
* [org.teiid.client.metadata.ParameterInfo](https://github.com/teiid/teiid/blob/master/client/src/main/java/org/teiid/client/metadata/ParameterInfo.java)
* [org.teiid.client.security.LogonResult](https://github.com/teiid/teiid/blob/master/client/src/main/java/org/teiid/client/security/LogonResult.java)
* [org.teiid.client.security.SessionToken](https://github.com/teiid/teiid/blob/master/client/src/main/java/org/teiid/client/security/SessionToken.java)
* [org.teiid.client.lob.LobChunk](https://github.com/teiid/teiid/blob/master/client/src/main/java/org/teiid/client/lob/LobChunk.java)
* [org.teiid.core.types.ArrayImpl](https://github.com/teiid/teiid/blob/master/common-core/src/main/java/org/teiid/core/types/ArrayImpl.java)
* [org.teiid.core.types.Streamable](https://github.com/teiid/teiid/blob/master/common-core/src/main/java/org/teiid/core/types/Streamable.java)
* [org.teiid.core.types.BaseLob](https://github.com/teiid/teiid/blob/master/common-core/src/main/java/org/teiid/core/types/BaseLob.java)
* [org.teiid.dqp.message.RequestID](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/dqp/message/RequestID.java)
* [org.teiid.dqp.message.AtomicRequestID](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/dqp/message/AtomicRequestID.java)
* [org.teiid.replication.jgroups.AddressWrapper](https://github.com/teiid/teiid/blob/master/runtime/src/main/java/org/teiid/replication/jgroups/AddressWrapper.java)

## Teiid Client

[Teiid JDBC Client]({{ site.baseurl }}/teiid-jdbc-client).

## Teiid Language

[Teiid Language API]({{ site.baseurl }}/teiid-language-api).

## Teiid Translator

[Teiid Translator API]({{ site.baseurl }}/teiid-translator-api).

## [ConnectorWork](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/dqp/internal/datamgr/ConnectorWork.java)

Client execute JDBC query sql be convert to a `Command` object, pass it to Engine DQP Process layer as DataTierTupleSource, then translator layer is necessary for translating data as below figure:

![teiid connector logic]({{ site.baseurl }}/assets/blog/connectorworkitem.jpg)

[org.teiid.dqp.internal.datamgr.ConnectorWork](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/dqp/internal/datamgr/ConnectorWork.java) is a internal used interface, but it's critical in Teiid Engine, it defined methods as below figure to operate `Teiid Connectors` layer.

![teiid connector work]({{ site.baseurl }}/assets/blog/ConnectorWork.gif)

[org.teiid.dqp.internal.datamgr.ConnectorWorkItem](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/dqp/internal/datamgr/ConnectorWorkItem.java) implements [org.teiid.dqp.internal.datamgr.ConnectorWork](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/dqp/internal/datamgr/ConnectorWork.java), we will look into it's method's in the following.

### execute()

Its main function is create a translator Execution, then invoke Execution's execute() method, the completed procedure like:

* Create Data Source Connection base on JCA connector implementation
* Create translator Execution with translator ExecutionFactory
* Invoke translator Execution's execute() method

### more()

Usually this methods be invoked after execute(), this method will invoke Execution's next() method repeatedly, return list of rows existed in data source.
