---
layout: blog
title:  "Teiid  Performance Tuning - Memory Management Examples"
date:   2015-07-22 17:00:00
categories: teiid
permalink: /teiid-memory
author: Kylin Soong
duoshuoid: ksoong2015072201
excerpt: Teiid  Performance Tuning, Memory Management Examples
---

As [Teiid Memory Management](https://docs.jboss.org/author/display/TEIID/Memory+Management), the BufferManager is responsible for tracking both memory and disk usage by Teiid. Configuring the BufferManager properly is one of the most important parts of ensuring high performance. 

This article including a series of Q/A, or examples, can be thought of a supplement of [Teiid Memory Management](https://docs.jboss.org/author/display/TEIID/Memory+Management) document.

## Teiid Memory Management Q/A

#### 1. What's the prossible properties use to configure BufferManager? and how to implement?

All the properties that start with "buffer-service" used to configure BufferManager, it including:

* useDisk
* encryptFiles
* processorBatchSize
* maxOpenFiles
* maxFileSize
* maxProcessingKb
* maxReserveKb
* maxBufferSpace
* inlineLobs
* memoryBufferSpace
* maxStorageObjectSize
* memoryBufferOffHeap

Read these properties via CLI command:

~~~
/subsystem=teiid:read-attribute(name=buffer-service-use-disk)
/subsystem=teiid:read-attribute(name=buffer-service-encrypt-files)
/subsystem=teiid:read-attribute(name=buffer-service-processor-batch-size)
/subsystem=teiid:read-attribute(name=buffer-service-max-open-files)
/subsystem=teiid:read-attribute(name=buffer-service-max-file-size)
/subsystem=teiid:read-attribute(name=buffer-service-max-processing-kb)
/subsystem=teiid:read-attribute(name=buffer-service-max-reserve-kb)
/subsystem=teiid:read-attribute(name=buffer-service-max-buffer-space)
/subsystem=teiid:read-attribute(name=buffer-service-inline-lobs)
/subsystem=teiid:read-attribute(name=buffer-service-memory-buffer-space)
/subsystem=teiid:read-attribute(name=buffer-service-max-storage-object-size)
/subsystem=teiid:read-attribute(name=buffer-service-memory-buffer-off-heap)
~~~

Write this properties via CLI command:

~~~
/subsystem=teiid:write-attribute(name=buffer-service-use-disk,value=true)
/subsystem=teiid:write-attribute(name=buffer-service-encrypt-files,value=false)
/subsystem=teiid:write-attribute(name=buffer-service-processor-batch-size,value=256)
/subsystem=teiid:write-attribute(name=buffer-service-max-open-files,value=64)
/subsystem=teiid:write-attribute(name=buffer-service-max-file-size,value=2048)
/subsystem=teiid:write-attribute(name=buffer-service-max-processing-kb,value=-1)
/subsystem=teiid:write-attribute(name=buffer-service-max-reserve-kb,value=-1)
/subsystem=teiid:write-attribute(name=buffer-service-max-buffer-space,value=51200)
/subsystem=teiid:write-attribute(name=buffer-service-max-inline-lobs,value=true)
/subsystem=teiid:write-attribute(name=buffer-service-memory-buffer-space,value=-1)
/subsystem=teiid:write-attribute(name=buffer-service-max-storage-object-size,value=8388608)
/subsystem=teiid:write-attribute(name=buffer-service-memory-buffer-off-heap,value=true）
~~~
