---
layout: blog
title:  "Teiid DDL behavior with samples"
date:   2014-08-15 17:57:12
categories: teiid
author: Kylin Soong
duoshuoid: ksoong20140815
---

Teiid is a data virtualization system that allows applications to use data from multiple, heterogenous data stores. Teiid supports a subset of DDL at runtime to create/drop temporary tables and to manipulate procedure and view definitions, more details refer to [https://docs.jboss.org/author/display/TEIID/DDL+Commands](https://docs.jboss.org/author/display/TEIID/DDL+Commands).

This documents supply a series runnable sample to demonstrate Teiid DDL behavior.

[The Completed Sample Code](https://github.com/kylinsoong/teiid-samples/blob/master/teiid-quickstart/src/test/java/com/teiid/quickstart/TestTeiidServerJDBC.java).

### view

* view can be created explicitly via the metadata supplied to Teiid at deploy time
* Teiid DO NOT support create view via JDBC
* Teiid support alter view via JDBC

~~~
	@Test
	public void testDDLAlterView() throws Exception {
	
		assertEquals(10, JDBCUtil.countResults(conn, "SELECT * FROM SYMBOLS"));
		JDBCUtil.executeUpdate(conn, "ALTER VIEW SYMBOLS AS SELECT Marketdata.symbol FROM Marketdata WHERE Marketdata.symbol = 'RHT'");
		assertEquals(1, JDBCUtil.countResults(conn, "SELECT * FROM SYMBOLS"));
		JDBCUtil.executeUpdate(conn, "ALTER VIEW SYMBOLS AS SELECT Marketdata.symbol FROM Marketdata");
		
		assertEquals("HELLO WORLD", JDBCUtil.query(conn, "SELECT * FROM HelloWorld"));
		JDBCUtil.executeUpdate(conn, "ALTER VIEW HelloWorld as SELECT 'ABCDEFGH'");
		assertEquals("ABCDEFGH", JDBCUtil.query(conn, "SELECT * FROM HelloWorld"));
		JDBCUtil.executeUpdate(conn, "ALTER VIEW HelloWorld as SELECT 'HELLO WORLD'");
	}
~~~

###  Local Temporary Tables

Local Temporary Tables only support created in runtime via JDBC

~~~
	@Test
	public void testDDLLocalTempTables() throws Exception {
	
		assertTrue(JDBCUtil.executeUpdate(conn, "CREATE LOCAL TEMPORARY TABLE TEMP (id SERIAL NOT NULL, name string, PRIMARY KEY (id))"));
		for(int i = 0 ; i < 3 ; i ++) {
			JDBCUtil.executeUpdate(conn, "INSERT INTO TEMP (name) VALUES ('test-name-" + i + "')");
		}
		assertTrue(JDBCUtil.executeUpdate(conn, "DELETE FROM TEMP WHERE id = 2"));
		assertTrue(JDBCUtil.executeUpdate(conn, "UPDATE TEMP SET name = 'Kylin Soong' WHERE id = 3"));
		assertEquals("Kylin Soong", JDBCUtil.query(conn, "SELECT name FROM TEMP WHERE id = 3"));
		assertTrue(JDBCUtil.executeUpdate(conn, "DROP TABLE TEMP"));
	}
~~~

### Global Temporary Tables



