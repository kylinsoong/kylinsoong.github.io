---
layout: blog
title:  "Understanding Teiid Metadata"
date:   2016-03-26 17:00:00
categories: teiid
permalink: /teiid-metadata
author: Kylin Soong
duoshuoid: ksoong2015032601
excerpt: How MetadataStore, MetadataRepository, SystemMetadata, QueryMetadataInterface run and work? How metadata be loaded? How runtime query conponents access the metadata
---

* Table of contents
{:toc}

## SystemMetadata loading in VDBRepository startup

In Teiid, every VDB reference a VDBRepository, once VDBRepository startup, it will load System Metadata, `SystemMetadata` is the API to operate with SystemMetadata:

~~~
SystemMetadata.getInstance().getSystemStore();
~~~

The System Metadata defined in [types.dat](https://raw.githubusercontent.com/teiid/teiid/master/engine/src/main/resources/org/teiid/metadata/types.dat), [SYS.sql](https://raw.githubusercontent.com/teiid/teiid/master/engine/src/main/resources/org/teiid/metadata/SYS.sql), [SYSADMIN.sql](https://raw.githubusercontent.com/teiid/teiid/master/engine/src/main/resources/org/teiid/metadata/SYSADMIN.sql), the loading order like:

1. [types.dat](https://raw.githubusercontent.com/teiid/teiid/master/engine/src/main/resources/org/teiid/metadata/types.dat) - define all supported datatypes
2. [SYS.sql](https://raw.githubusercontent.com/teiid/teiid/master/engine/src/main/resources/org/teiid/metadata/SYS.sql) - Contain **System Tables:** Columns, DataTypes, KeyColumns, Keys, ProcedureParams, Procedures, FunctionParams, Functions, Properties, ReferenceKeyColumns, Schemas, Tables, VirtualDatabases; **System Procedures:** getXMLSchemas, ARRAYITERATE; **System Views:** spatial_ref_sys, GEOMETRY_COLUMNS
3. [SYSADMIN.sql](https://raw.githubusercontent.com/teiid/teiid/master/engine/src/main/resources/org/teiid/metadata/SYSADMIN.sql) - Contain **Tables:** Usage, MatViews, VDBResources, Triggers, Views, StoredProcedures; **Procedures:** isLoggable, logMsg, refreshMatView, refreshMatViewRow, refreshMatViewRows, setColumnStats, setProperty, setTableStats, matViewStatus, loadMatView, updateMatView

## Metadata operations in VDB deploying

There are 3 phases of Metadata operations in VDB deploying:

1. Assign Metadata Repositories
2. Metadata loading
3. VDB finish deploy

### Assign Metadata Repositories

Assign Metadata Repositories means assign a [MetadataRepository](http://ksoong.org/teiid-uml-diagram#orgteiidmetadatametadatarepositoryfc) to each Model which contained in a VDB definition. Assuming a VDB contain 4 Models and the processing of assign Metadata Repositories likes

![Assign Metadata Repositories]({{ site.baseurl }}/assets/blog/teiid/teiid-assign-repository.png)

As above figure, the VDB contain 4 Models:

1. `MarketData` - define a source point to a csv file, which assigned a ChainingMetadataRepository contain a NativeMetadataRepository and a DirectQueryMetadataRepository
2. `Accounts` - define a source point to a RDBMS, which assigned a ChainingMetadataRepository contain a NativeMetadataRepository and a DirectQueryMetadataRepository
3. `Stocks` - is a virtual model, contains a DDL text metadata, which assigned a ChainingMetadataRepository contain a MetadataRepositoryWrapper and a MaterializationMetadataRepository, a MetadataRepositoryWrapper contain a DDLMetadataRepository and DDL Text String
4. `StocksMatModel` - is a virtual model, contains a DDL text metadata, which assigned a ChainingMetadataRepository contain a MetadataRepositoryWrapper and a MaterializationMetadataRepository, a MetadataRepositoryWrapper contain a DDLMetadataRepository and DDL Text String

All ChainingMetadataRepository, NativeMetadataRepository, DirectQueryMetadataRepository, MetadataRepositoryWrapper, DDLMetadataRepository and MaterializationMetadataRepository are sub-class of MetadataRepository, more details refer to [UML diagram](http://ksoong.org/teiid-uml-diagram#orgteiidmetadatametadatarepositoryfc).

### Metadata loading

Once [Assign Metadata Repositories](#Assign Metadata Repositories) finished, each Model has reference a [MetadataRepository](http://ksoong.org/teiid-uml-diagram#orgteiidmetadatametadatarepositoryfc), it's loadMetadata() methods be invoked, the following is the 4 models load metadata sequence diagram:

**MarketData Load Metadata**

![MarketData Load Metadata]({{ site.baseurl }}/assets/blog/teiid/teiid-file-load-metadata.png)

**Accounts Load Metadata**

![Accounts Load Metadata]({{ site.baseurl }}/assets/blog/teiid/teiid-jdbc-load-metadata.png)

**Stocks/StocksMatModel Load Metadata**

![Stocks Load Metadata]({{ site.baseurl }}/assets/blog/teiid/teiid-mat-load-metadata.png)

A MetadataFactory used in each Model's Metadata loading, MetadataFactory can merge each other, a MetadataFactory contains dataTypes, vdbResources, grants and a Schema, which related with tables, procedures, functions.

Once the last Model's Metadata loading finished, VDBRepository's finishDeployment() will be invoked, relate below section for more.

### VDB finish deploy

As below figure, the VDB finish deploy mainly contains: 

1. init runtime metadata API and attach it to VDB
2. validate the DDL SQL String which exist in VDB's virtual model
3. invoke VDBLifeCycleListener's finishedDeployment()

![VDB finish deploy]({{ site.baseurl }}/assets/blog/teiid/teiid-metadata-finished.png)

**Appendix-1: buildTransformationMetaData()**

Build runtime metadata API `QueryMetadataInterface1`'s implementation `TransformationMetadata`, this interface used by query components in runtime to access metadata. This implementation related with a VDB via VDB attachment:

~~~
TransformationMetadata metadata = buildTransformationMetaData(mergedVDB, getVisibilityMap(), mergedStore, getUDF(), systemFunctions, this.additionalStores);
QueryMetadataInterface qmi = metadata;
mergedVDB.addAttchment(QueryMetadataInterface.class, qmi);
mergedVDB.addAttchment(TransformationMetadata.class, metadata);
mergedVDB.addAttchment(MetadataStore.class, mergedStore);
~~~

**Appendix-2: Metadata Validator** 

Validate the SQL commands which existed in virtual model's DDL text metadata String.

**Appendix-3: MaterializationManager** 

Refer to [teiid-mat-view](http://ksoong.org/teiid-mat-view).

## Examples

This section contain examples to quick understand the Teiid Metadata.

### Load classpath ddl file

Assuming `customer.ddl` file under classpath, which define a series of Metadata, this example demonstrates how to load metadata from a classpath file.

~~~java
VDBMetaData vdb = new VDBMetaData();
vdb.setName("ExampleVDB");
vdb.setVersion(1);
Properties p = new Properties();
QueryParser parser = new QueryParser();
        
Map<String, Datatype> typeMap = SystemMetadata.getInstance().getRuntimeTypeMap();
        
ModelMetaData mmd = new ModelMetaData();
mmd.setName("ExampleMode");
vdb.addModel(mmd);
MetadataFactory factory = new MetadataFactory(vdb.getName(), vdb.getVersion(), "ExampleMode", typeMap, p, null);
parser.parseDDL(factory, loadReader("customer.ddl"));
MetadataStore systemStore = factory.asMetadataStore();
     
TransformationMetadata tm = new TransformationMetadata(vdb, new CompositeMetadataStore(systemStore), null, new SystemFunctionManager(typeMap).getSystemFunctions(), null);
vdb.addAttchment(QueryMetadataInterface.class, tm);
MetadataValidator validator = new MetadataValidator(typeMap, parser);
ValidatorReport report = validator.validate(vdb, systemStore);
if (report.hasItems()) {
   throw new TeiidRuntimeException(report.getFailureMessage());
}
~~~

