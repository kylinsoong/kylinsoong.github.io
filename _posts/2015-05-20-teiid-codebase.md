---
layout: blog
title:  "Teiid Code Analysis - Overview"
date:   2015-05-20 21:00:00
categories: teiid
permalink: /teiid-code
author: Kylin Soong
duoshuoid: ksoong2015052003
---

[Teiid](https://github.com/teiid/teiid) is the codebase for teiid project, this article will guide you how to look over the complete Teiid code.

## ThreadLocal

The following are ThreadLocal be used in teiid codebases:

* [org.teiid.resource.spi.ConnectionContext](https://github.com/teiid/teiid/blob/master/api/src/main/java/org/teiid/resource/spi/ConnectionContext.java)
* [org.teiid.net.socket.OioOjbectChannelFactory](https://github.com/teiid/teiid/blob/master/client/src/main/java/org/teiid/net/socket/OioOjbectChannelFactory.java)
* [org.teiid.core.util.TimestampWithTimezone](https://github.com/teiid/teiid/blob/master/common-core/src/main/java/org/teiid/core/util/TimestampWithTimezone.java)
* [org.teiid.core.types.XMLType](https://github.com/teiid/teiid/blob/master/common-core/src/main/java/org/teiid/core/types/XMLType.java)
* [org.teiid.core.types.StandardXMLTranslator](https://github.com/teiid/teiid/blob/master/common-core/src/main/java/org/teiid/core/types/StandardXMLTranslator.java)
* [org.teiid.translator.jdbc.JDBCExecutionFactory](https://github.com/teiid/teiid/blob/master/connectors/translator-jdbc/src/main/java/org/teiid/translator/jdbc/JDBCExecutionFactory.java)
* [org.teiid.dqp.internal.process.DQPWorkContext](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/dqp/internal/process/DQPWorkContext.java)
* [org.teiid.dqp.internal.process.RequestWorkItem](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/dqp/internal/process/RequestWorkItem.java)
* [org.teiid.query.optimizer.relational.RelationalPlanner](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/query/optimizer/relational/RelationalPlanner.java)
* [org.teiid.query.util.CommandContext](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/query/util/CommandContext.java)
* [org.teiid.query.function.source.XMLSystemFunctions](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/query/function/source/XMLSystemFunctions.java)
* [org.teiid.query.parser.QueryParser](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/query/parser/QueryParser.java)
* [org.teiid.common.buffer.impl.BufferManagerImpl](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/common/buffer/impl/BufferManagerImpl.java)
* [org.teiid.odata.ODataServletContainerDispatcher](https://github.com/teiid/teiid/blob/master/odata/src/main/java/org/teiid/odata/ODataServletContainerDispatcher.java)

## Java concurrent 

Teiid use quite a lot of `java.util.concurrent` class for multiple threads, lock, etc. The following give the quick link for these codes:

**Executor Service**

* [org.teiid.jdbc.ConnectionImpl](https://github.com/teiid/teiid/blob/master/client/src/main/java/org/teiid/jdbc/ConnectionImpl.java)
* [org.teiid.jdbc.EnhancedTimer](https://github.com/teiid/teiid/blob/master/client/src/main/java/org/teiid/jdbc/EnhancedTimer.java)
* [org.teiid.core.util.ExecutorUtils](https://github.com/teiid/teiid/blob/master/common-core/src/main/java/org/teiid/core/util/ExecutorUtils.java)
* [org.teiid.core.util.NamedThreadFactory](https://github.com/teiid/teiid/blob/master/common-core/src/main/java/org/teiid/core/util/NamedThreadFactory.java)
* [org.teiid.dqp.internal.process.ThreadReuseExecutor](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/dqp/internal/process/ThreadReuseExecutor.java)
* [org.teiid.dqp.internal.process.Request](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/dqp/internal/process/Request.java)
* [org.teiid.dqp.internal.process.TeiidExecutor](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/dqp/internal/process/TeiidExecutor.java)
* [org.teiid.dqp.internal.process.DQPCore](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/dqp/internal/process/DQPCore.java)
* [org.teiid.query.util.CommandContext](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/query/util/CommandContext.java)
* [org.teiid.common.buffer.impl.BufferFrontedFileStoreCache](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/common/buffer/impl/BufferFrontedFileStoreCache.java)
* [org.teiid.deployers.VDBStatusChecker](https://github.com/teiid/teiid/blob/master/runtime/src/main/java/org/teiid/deployers/VDBStatusChecker.java)
* [org.teiid.runtime.EmbeddedServer](https://github.com/teiid/teiid/blob/master/runtime/src/main/java/org/teiid/runtime/EmbeddedServer.java)
* [org.teiid.runtime.MaterializationManager](https://github.com/teiid/teiid/blob/master/runtime/src/main/java/org/teiid/runtime/MaterializationManager.java)
* [org.teiid.runtime.EmbeddedConfiguration](https://github.com/teiid/teiid/blob/master/runtime/src/main/java/org/teiid/runtime/EmbeddedConfiguration.java)
* [org.teiid.transport.SocketListener](https://github.com/teiid/teiid/blob/master/runtime/src/main/java/org/teiid/transport/SocketListener.java)
* [org.teiid.replication.jgroups.JGroupsObjectReplicator](https://github.com/teiid/teiid/blob/master/runtime/src/main/java/org/teiid/replication/jgroups/JGroupsObjectReplicator.java)

**Future and FutureTask**

* [org.teiid.jdbc.EnhancedTimer](https://github.com/teiid/teiid/blob/master/client/src/main/java/org/teiid/jdbc/EnhancedTimer.java)
* [org.teiid.client.util.ResultsFuture](https://github.com/teiid/teiid/blob/master/client/src/main/java/org/teiid/client/util/ResultsFuture.java)
* [org.teiid.client.lob.StreamingLobChunckProducer](https://github.com/teiid/teiid/blob/master/client/src/main/java/org/teiid/client/lob/StreamingLobChunckProducer.java)
* [org.teiid.net.socket.SocketServerConnectionFactory](https://github.com/teiid/teiid/blob/master/client/src/main/java/org/teiid/net/socket/SocketServerConnectionFactory.java)
* [org.teiid.net.socket.OioOjbectChannelFactory](https://github.com/teiid/teiid/blob/master/client/src/main/java/org/teiid/net/socket/OioOjbectChannelFactory.java)
* [org.teiid.net.socket.ObjectChannel](https://github.com/teiid/teiid/blob/master/client/src/main/java/org/teiid/net/socket/ObjectChannel.java)
* [org.teiid.net.socket.SocketServerConnection](https://github.com/teiid/teiid/blob/master/client/src/main/java/org/teiid/net/socket/SocketServerConnection.java)
* [org.teiid.resource.adapter.ws.WSConnectionImpl](https://github.com/teiid/teiid/blob/master/connectors/connector-ws/src/main/java/org/teiid/resource/adapter/ws/WSConnectionImpl.java)
* [org.teiid.dqp.internal.process.DataTierTupleSource](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/dqp/internal/process/DataTierTupleSource.java)
* [org.teiid.dqp.internal.process.FutureWork](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/dqp/internal/process/FutureWork.java)
* [org.teiid.dqp.internal.process.DataTierManagerImpl](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/dqp/internal/process/DataTierManagerImpl.java)
* [org.teiid.dqp.internal.process.DQPWorkContext](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/dqp/internal/process/DQPWorkContext.java)
* [org.teiid.dqp.internal.process.RequestWorkItem](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/dqp/internal/process/RequestWorkItem.java)
* [org.teiid.dqp.internal.process.DQPCore](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/dqp/internal/process/DQPCore.java)
* [org.teiid.query.tempdata.TempTableDataManager](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/query/tempdata/TempTableDataManager.java)
* [org.teiid.transport.SSLAwareChannelHandler](https://github.com/teiid/teiid/blob/master/runtime/src/main/java/org/teiid/transport/SSLAwareChannelHandler.java)
* [org.teiid.transport.LocalServerConnection](https://github.com/teiid/teiid/blob/master/runtime/src/main/java/org/teiid/transport/LocalServerConnection.java)

**ReentrantReadWriteLock, ReentrantLock and Condition**

* [org.teiid.jdbc.EnhancedTimer](https://github.com/teiid/teiid/blob/master/client/src/main/java/org/teiid/jdbc/EnhancedTimer.java)
* [org.teiid.query.tempdata.TempTable](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/query/tempdata/TempTable.java)
* [org.teiid.common.buffer.impl.BufferFrontedFileStoreCache](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/common/buffer/impl/BufferFrontedFileStoreCache.java)
* [org.teiid.common.buffer.impl.BlockStore](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/common/buffer/impl/BlockStore.java)

* [org.teiid.common.buffer.STree](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/common/buffer/STree.java)
* [org.teiid.common.buffer.impl.BufferManagerImpl](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/common/buffer/impl/BufferManagerImpl.java)
* [org.teiid.common.buffer.impl.BufferFrontedFileStoreCache](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/common/buffer/impl/BufferFrontedFileStoreCache.java)
* [java.org.teiid.deployers.VDBRepository](https://github.com/teiid/teiid/blob/master/runtime/src/main/java/org/teiid/deployers/VDBRepository.java)
* [java.org.teiid.replication.jgroups.JGroupsInputStream](https://github.com/teiid/teiid/blob/master/runtime/src/main/java/org/teiid/replication/jgroups/JGroupsInputStream.java)


* [org.teiid.common.buffer.impl.BufferManagerImpl](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/common/buffer/impl/BufferManagerImpl.java)
* [org.teiid.common.buffer.impl.BufferFrontedFileStoreCache](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/common/buffer/impl/BufferFrontedFileStoreCache.java)
* [org.teiid.deployers.VDBRepository](https://github.com/teiid/teiid/blob/master/runtime/src/main/java/org/teiid/deployers/VDBRepository.java)
* [org.teiid.replication.jgroups.JGroupsInputStream](https://github.com/teiid/teiid/blob/master/runtime/src/main/java/org/teiid/replication/jgroups/JGroupsInputStream.java)

**Semaphore**

* [org.teiid.common.buffer.impl.BufferFrontedFileStoreCache](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/common/buffer/impl/BufferFrontedFileStoreCache.java)

**ConcurrentHashMap, ConcurrentSkipListMap, ConcurrentLinkedQueue, SynchronousQueue, CopyOnWriteArrayList, ConcurrentSkipListSet, LinkedBlockingQueue**

* [org.teiid.logging.JavaLogger](https://github.com/teiid/teiid/blob/master/api/src/main/java/org/teiid/logging/JavaLogger.java)
* [org.teiid.jdbc.ConnectionImpl](https://github.com/teiid/teiid/blob/master/client/src/main/java/org/teiid/jdbc/ConnectionImpl.java)
* [org.teiid.net.socket.SocketServerInstanceImpl](https://github.com/teiid/teiid/blob/master/client/src/main/java/org/teiid/net/socket/SocketServerInstanceImpl.java)
* [org.teiid.net.socket.SocketServerConnection](https://github.com/teiid/teiid/blob/master/client/src/main/java/org/teiid/net/socket/SocketServerConnection.java)
* [org.teiid.translator.mongodb.MongoDBSelectVisitor](https://github.com/teiid/teiid/blob/master/connectors/translator-mongodb/src/main/java/org/teiid/translator/mongodb/MongoDBSelectVisitor.java)
* [org.teiid.translator.coherence.util.ObjectSourceMethodManager](https://github.com/teiid/teiid/blob/master/connectors/sandbox/translator-coherence/src/main/java/org/teiid/translator/coherence/util/ObjectSourceMethodManager.java)
* [org.teiid.dqp.internal.datamgr.TranslatorRepository](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/dqp/internal/datamgr/TranslatorRepository.java)
* [org.teiid.dqp.internal.datamgr.ConnectorManager](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/dqp/internal/datamgr/ConnectorManager.java)
* [org.teiid.dqp.internal.datamgr.ConnectorManagerRepository](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/dqp/internal/datamgr/ConnectorManagerRepository.java)
* [org.teiid.dqp.internal.process.multisource.MultiSourceMetadataWrapper](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/dqp/internal/process/multisource/MultiSourceMetadataWrapper.java)
* [org.teiid.dqp.internal.process.DQPCore](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/dqp/internal/process/DQPCore.java)
* [org.teiid.dqp.service.TransactionContext](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/dqp/service/TransactionContext.java)
* [org.teiid.query.tempdata.GlobalTableStoreImpl](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/query/tempdata/GlobalTableStoreImpl.java)
* [org.teiid.query.tempdata.TempTableStore](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/query/tempdata/TempTableStore.java)
* [org.teiid.common.buffer.impl.MemoryStorageManager](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/common/buffer/impl/MemoryStorageManager.java)
* [org.teiid.common.buffer.impl.BufferManagerImpl](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/common/buffer/impl/BufferManagerImpl.java)
* [org.teiid.common.buffer.impl.SizeUtility](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/common/buffer/impl/SizeUtility.java)
* [org.teiid.common.buffer.impl.BufferFrontedFileStoreCache](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/common/buffer/impl/BufferFrontedFileStoreCache.java)
* [org.teiid.jboss.JBossLogger](https://github.com/teiid/teiid/blob/master/jboss-integration/src/main/java/org/teiid/jboss/JBossLogger.java)
* [org.teiid.deployers.EventDistributorImpl](https://github.com/teiid/teiid/blob/master/runtime/src/main/java/org/teiid/deployers/EventDistributorImpl.java)
* [org.teiid.deployers.VDBRepository](https://github.com/teiid/teiid/blob/master/runtime/src/main/java/org/teiid/deployers/VDBRepository.java)
* [org.teiid.services.SessionServiceImpl](https://github.com/teiid/teiid/blob/master/runtime/src/main/java/org/teiid/services/SessionServiceImpl.java)
* [org.teiid.runtime.EmbeddedServer](https://github.com/teiid/teiid/blob/master/runtime/src/main/java/org/teiid/runtime/EmbeddedServer.java)
* [org.teiid.transport.SSLAwareChannelHandler](https://github.com/teiid/teiid/blob/master/runtime/src/main/java/org/teiid/transport/SSLAwareChannelHandler.java)
* [org.teiid.replication.jgroups.JGroupsObjectReplicator](https://github.com/teiid/teiid/blob/master/runtime/src/main/java/org/teiid/replication/jgroups/JGroupsObjectReplicator.java)

* [org.teiid.metadata.AbstractMetadataRecord](https://github.com/teiid/teiid/blob/master/api/src/main/java/org/teiid/metadata/AbstractMetadataRecord.java)
* [org.teiid.query.tempdata.TempTableStore](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/query/tempdata/TempTableStore.java)
* [org.teiid.common.buffer.impl.LrfuEvictionQueue](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/common/buffer/impl/LrfuEvictionQueue.java)
* [org.teiid.deployers.VDBRepository](https://github.com/teiid/teiid/blob/master/runtime/src/main/java/org/teiid/deployers/VDBRepository.java)
* [org.teiid.runtime.AbstractVDBDeployer](https://github.com/teiid/teiid/blob/master/runtime/src/main/java/org/teiid/runtime/AbstractVDBDeployer.java)

* [org.teiid.common.queue.TestThreadReuseExecutor](https://github.com/teiid/teiid/blob/master/engine/src/test/java/org/teiid/common/queue/TestThreadReuseExecutor.java)
* [org.teiid.transport.ODBCClientInstance](https://github.com/teiid/teiid/blob/master/runtime/src/main/java/org/teiid/transport/ODBCClientInstance.java)

* [org.teiid.core.util.ExecutorUtils](https://github.com/teiid/teiid/blob/master/common-core/src/main/java/org/teiid/core/util/ExecutorUtils.java)
* [org.teiid.dqp.internal.process.ThreadReuseExecutor](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/dqp/internal/process/ThreadReuseExecutor.java)

* [org.teiid.adminapi.impl.DataPolicyMetadata](https://github.com/teiid/teiid/blob/master/admin/src/main/java/org/teiid/adminapi/impl/DataPolicyMetadata.java)

* [org.teiid.jdbc.EnhancedTimer](https://github.com/teiid/teiid/blob/master/client/src/main/java/org/teiid/jdbc/EnhancedTimer.java)

* [org.teiid.core.util.ExecutorUtils](https://github.com/teiid/teiid/blob/master/common-core/src/main/java/org/teiid/core/util/ExecutorUtils.java)

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

## Links

* [Teiid Language API]({{ site.baseurl }}/teiid-language-api).
* [Teiid Translator API]({{ site.baseurl }}/teiid-translator-api).
* [Teiid Metadata API]({{ site.baseurl }}/teiid-metadata-api).
* [Teiid BufferManager]({{ site.baseurl }}/teiid-buffer).
