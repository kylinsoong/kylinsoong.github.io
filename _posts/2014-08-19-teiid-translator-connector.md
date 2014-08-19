---
layout: blog
title:  "Teiid File Translator and Connector"
date:   2014-08-19 19:20:12
categories: teiid
permalink: /teiid-file-connector
author: Kylin Soong
duoshuoid: ksoong2014081902
---

Before starting this documents we run a example, assume a text file [marketdata.csv](https://github.com/kylinsoong/teiid-samples/blob/master/teiid-quickstart/src/file/marketdata.csv) under $ROOT/src/file, run `@Test public void testQuery()` in [TestFileTranslatorConnector](https://github.com/kylinsoong/teiid-samples/blob/master/teiid-quickstart/src/test/java/com/teiid/quickstart/file/TestFileTranslatorConnector.java) will query all data from that text file.

~~~
	@Test
	public void testQuery() throws Exception {
		init();
		assertNotNull(conn);
		String query = "SELECT * FROM Marketdata";
		assertEquals(10, JDBCUtil.countResults(conn, query));
	}
~~~

Note that, above code show JDBC query use SQL statement `SELECT * FROM Marketdata`, the main reason this works due to Translator and Connector we set in init() method:

~~~
		FileExecutionFactory executionFactory = new FileExecutionFactory();
		server.addTranslator("file", executionFactory);
		
		FileManagedConnectionFactory fileManagedconnectionFactory = new FileManagedConnectionFactory();
		fileManagedconnectionFactory.setParentDirectory("src/file");
		ConnectionFactory connectionFactory = fileManagedconnectionFactory.createConnectionFactory();
		ConnectionFactoryProvider<ConnectionFactory> connectionFactoryProvider = new EmbeddedServer.SimpleConnectionFactoryProvider<ConnectionFactory>(connectionFactory);
		server.addConnectionFactoryProvider("java:/marketdata-file", connectionFactoryProvider);
~~~

and the VDB we deployed:

~~~
server.deployVDB(new FileInputStream(new File("src/vdb/marketdata-vdb.xml")));
~~~

[The Completed marketdata-vdb.xml](https://github.com/kylinsoong/teiid-samples/blob/master/teiid-quickstart/src/vdb/marketdata-vdb.xml)

This document will dive into Teiid File Translator and Connector, and how vdb model be analysed by Teiid Engine.

## File Translator

The File Translator source code located in [https://github.com/teiid/teiid/tree/master/connectors/translator-file](https://github.com/teiid/teiid/tree/master/connectors/translator-file). The `FileExecutionFactory` extends the `ExecutionFactory` as below figure:

![Teiid FileExecutionFactory]({{ site.baseurl }}/assets/blog/FileExecutionFactory.gif)

The following test code in [TestFileTranslatorConnector](https://github.com/kylinsoong/teiid-samples/blob/master/teiid-quickstart/src/test/java/com/teiid/quickstart/file/TestFileTranslatorConnector.java) used to test FileExecutionFactory:

~~~
	@Test
	public void testFileExecutionFactory() throws Exception {
		
		FileConnection conn = new FileConnectionImpl("src/file", new HashMap<String, String> (), true);
		assertTrue(conn.getFile("marketdata.csv").exists());
		Literal literal = new Literal("marketdata.csv", TypeFacility.RUNTIME_TYPES.STRING);
		Argument argument = new Argument(Direction.IN, literal, TypeFacility.RUNTIME_TYPES.STRING, null);
		Call call = LanguageFactory.INSTANCE.createCall("getTextFiles", Arrays.asList(argument), null);
		FileExecutionFactory fileExecutionFactory = new FileExecutionFactory();
		ProcedureExecution pe = fileExecutionFactory.createProcedureExecution(call, null, null, conn);
		pe.execute();
		assertNotNull(pe.next());
	}
~~~

## File Connector

The File Connector source code located in [https://github.com/teiid/teiid/tree/master/connectors/connector-file](https://github.com/teiid/teiid/tree/master/connectors/connector-file). The main class UML as blow:

![Teiid FileConnectionImpl]({{ site.baseurl }}/assets/blog/FileConnectionImpl.gif)

* `Connection` come from java connector api. A Connection represents an application-level handle that is used by a client to access the underlying physical connection. The actual physical connection associated with a Connection instance is represented by a ManagedConnection instance.
* `BasicConnection` and `FileConnection` come from Teiid API

![Teiid FileManagedConnectionFactory]({{ site.baseurl }}/assets/blog/FileManagedConnectionFactory.gif)

Three jav connector API be used:

* javax.resource.spi.ManagedConnectionFactory
* javax.resource.spi.ResourceAdapterAssociation
* javax.resource.spi.ValidatingManagedConnectionFactory

![Teiid FileResourceAdapter]({{ site.baseurl }}/assets/blog/FileResourceAdapter.gif)

The java connector API `javax.resource.spi.ResourceAdapter` represents a resource adapter instance and contains operations for lifecycle management and message endpoint setup. A concrete implementation of this interface is required to be a JavaBean.

The following method used to test file mapping:

~~~
	@Test
	public void testFileMapping() throws Exception {
		FileManagedConnectionFactory fmcf = new FileManagedConnectionFactory();
		fmcf.setParentDirectory("src/file");
		fmcf.setFileMapping("x=marketdata.csv,y=noexist.csv");
		BasicConnectionFactory<FileConnectionImpl> bcf = fmcf.createConnectionFactory();
		FileConnection fc = (FileConnection) bcf.getConnection();
		File f = fc.getFile("x");
		assertEquals("src/file/marketdata.csv", f.getPath());
		assertTrue(f.exists());
		f = fc.getFile("y");
		assertEquals("src/file/noexist.csv", f.getPath());
		assertFalse(f.exists());
	}
~~~

The Following code used test parent file:

~~~
	@Test
	public void testParentPaths() throws Exception {
		FileManagedConnectionFactory fmcf = new FileManagedConnectionFactory();
		fmcf.setParentDirectory("src/file");
		fmcf.setAllowParentPaths(true);
		BasicConnectionFactory<FileConnectionImpl> bcf = fmcf.createConnectionFactory();
		FileConnection fc = bcf.getConnection();
		File f = fc.getFile(".." + File.separator + "file");
		assertTrue(f.exists());
		assertTrue(f.isDirectory());
	}
~~~
