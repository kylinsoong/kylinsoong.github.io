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

Once [Assign Metadata Repositories](#assign-metadata-repositories) finished, each Model has reference a [MetadataRepository](http://ksoong.org/teiid-uml-diagram#orgteiidmetadatametadatarepositoryfc), each of them's loadMetadata() methods be invoked iteratively, continue the VDB in [Assign Metadata Repositories](#assign-metadata-repositories), the following is the 4 models load metadata sequence diagram:

**MarketData Load Metadata**

![MarketData Load Metadata]({{ site.baseurl }}/assets/blog/teiid/teiid-file-load-metadata.png)

**Accounts Load Metadata**

![Accounts Load Metadata]({{ site.baseurl }}/assets/blog/teiid/teiid-jdbc-load-metadata.png)

* Before loading metadada, a `MetadataFactory`, `ExecutionFactory`(only for Source Model) and `ConnectionFactory`(only for Source Model) be created, passed as the parameters of ChainingMetadataRepository's loadMetadata() method.
* Loading metadata, will load all source metadata(tables, columns, primary keys, index info, foreign keys) into `MetadataFactory`. 
* After load metadata, MetadataFactory's `mergeInto (MetadataStore store)` be invoked, MetadataFactory's metadata be merged into a VDB scope MetadataStore.

**Stocks/StocksMatModel Load Metadata**

![Stocks Load Metadata]({{ site.baseurl }}/assets/blog/teiid/teiid-mat-load-metadata.png)

* Before loading metadada, a `MetadataFactory` be created
* Loading metadata, in DDLMetadataRepository, MetadataFactory's parse() invoked, parse the ddl text to Tables and Columns, a example refer to [Example.2 MetadataFactory parse ddl text](#example2-metadatafactory-parse-ddl-text)
* After load metadata, MetadataFactory's `mergeInto (MetadataStore store)` be invoked, MetadataFactory's metadata be merged into a VDB scope MetadataStore.

A MetadataFactory used in each Model's Metadata loading, MetadataFactory can merge into a global VDB scope MetadataStore, which contains dataTypes, vdbResources, grants and a Schema, related with tables, procedures, functions.

> **Note that, the result of Metadata loading load  all metadata to a VDB scope MetadataStore, metadata in MetadataStore saved by Schema(each Model in VDB reference a Schema).** 

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

> NOTE: `TransformationMetadata` base on VDB Scope Metadata `MetadataStore`, both `TransformationMetadata` and `MetadataStore` be added as VDB attachment. 

**Appendix-2: Metadata Validator** 

Validate all Metadata existed in Global VDB Scope `MetadataStore` with the following MetadataRule:

* SourceModelArtifacts - do not allow foreign tables, source functions in view model and vice versa 
* CrossSchemaResolver - resolves the artifacts that are dependent upon objects from other schemas materialization sources, fk and data types, ensures that even if cached metadata is used that we resolve to a single instance
* ResolveQueryPlans - Resolves metadata query plans to make sure they are accurate
* MinimalMetadata - At minimum the model must have table/view, procedure or function 
* MatViewPropertiesValidator - Validate the Materrialization Properties 

**Appendix-3: MaterializationManager** 

Refer to [teiid-mat-view](http://ksoong.org/teiid-mat-view#materializationmanager-finishdeployment).

## Examples

This section contain examples to quick understand the Teiid Metadata.

### Example.1: Load classpath ddl file

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

### Example.2 MetadataFactory parse ddl text

[Sample DDL Text File]({{ site.baseurl }}/assets/download/teiid-sample-ddl-txt) contain dll text, this example will demonstrate how MetadataFactory parse ddl text.

~~~
ModelMetaData mmd = new ModelMetaData();
mmd.setName("ExampleMode");
MetadataFactory factory = new MetadataFactory("VDB", "1", datatypes, mmd);
factory.setBuiltinDataTypes(SystemMetadata.getInstance().getRuntimeTypeMap());
factory.getSchema().setPhysical(false);
factory.setParser(new QueryParser()); 

factory.parse(new StringReader(ddl));
for (Table t :factory.getSchema().getTables().values()) {
    List<Column> matViewColumns = t.getColumns();
    for(int i = 0 ; i < matViewColumns.size() ; i ++){
        Column c = matViewColumns.get(i);
        System.out.println(c.getName() + ", " + c.getDatatype());
    }
   System.out.println(t.getProperty("{http://www.teiid.org/ext/relational/2012}MATVIEW_STATUS_TABLE", false));
}
~~~

Run code will output:

~~~
id, Datatype name=string, basetype name=anySimpleType, runtimeType=string, javaClassName=java.lang.String, ObjectID=mmuuid:bf6c34c0-c442-1e24-9b01-c8207cd53eb7
a, Datatype name=string, basetype name=anySimpleType, runtimeType=string, javaClassName=java.lang.String, ObjectID=mmuuid:bf6c34c0-c442-1e24-9b01-c8207cd53eb7
b, Datatype name=string, basetype name=anySimpleType, runtimeType=string, javaClassName=java.lang.String, ObjectID=mmuuid:bf6c34c0-c442-1e24-9b01-c8207cd53eb7
c, Datatype name=string, basetype name=anySimpleType, runtimeType=string, javaClassName=java.lang.String, ObjectID=mmuuid:bf6c34c0-c442-1e24-9b01-c8207cd53eb7
status
~~~
