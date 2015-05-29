---
layout: blog
title:  "Teiid Metadata API"
date:   2015-05-18 18:00:00
categories: teiid
permalink: /teiid-metadata-api
author: Kylin Soong
duoshuoid: ksoong2015051802
excerpt: Teiid Metadata API diagram and usage sample
---

Teiid MetaData API Hierarchy Diagram:

![Teiid MetaData API Hierarchy]({{ site.baseurl }}/assets/blog/teiid-metadata.png)

Teiid JDBCMetdataProcessor is an example which will load all tables, procedures and functions via JDBC Connection, as below codes:

~~~
VDBMetaData vdb = new VDBMetaData();
		
vdb.setName("TestVDB");
vdb.setVersion(1);
vdb.addProperty("UseConnectorMetadata", "true");
		
ModelMetaData model = new ModelMetaData();
model.setName("Accounts");
model.setModelType("PHYSICAL");
model.setVisible(true);
model.setPath(null);
model.addProperty("importer.useFullSchemaName", "false");
model.addSourceMapping("h2-connector", "translator-h2", "java:/accounts-ds");
vdb.addModel(model);
		
Map<String, Datatype> datatypes = SystemMetadata.getInstance().getRuntimeTypeMap();
MetadataFactory factory = new MetadataFactory(vdb.getName(), vdb.getVersion(), datatypes, model);
factory.setBuiltinDataTypes(datatypes);
factory.getSchema().setPhysical(model.isSource());
factory.setParser(new QueryParser());
		
Connection conn = EmbeddedHelper.newDataSource(H2_JDBC_DRIVER, H2_JDBC_URL, H2_JDBC_USER, H2_JDBC_PASS).getConnection();
		
JDBCMetdataProcessor processor = new JDBCMetdataProcessor();
processor.process(factory, conn);
		
Map<String, Table> map = factory.getSchema().getTables();
		
dumpTables(map);
~~~

## MetadataRepository

MetadataRepository is a hook for externalizing view, procedure, and other metadata, it's UML diagram as below:

![Teiid MetaData API Hierarchy]({{ site.baseurl }}/assets/blog/teiid-metadatarepo.png)
