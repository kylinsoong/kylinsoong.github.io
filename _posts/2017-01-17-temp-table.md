---
layout: blog
title:  "Teiid Temp Tables"
date:   2017-01-17 20:00:00
categories: teiid
permalink: /temp-tables
author: Kylin Soong
duoshuoid: ksoong2017011702
excerpt: Local Temporary Tables, Global Temporary Tables, Global and Local Temporary Table Features, Foreign Temporary Tables
---

* Table of contents
{:toc}

## Local Temporary Tables

As per [Teiid Document](https://teiid.gitbooks.io/documents/content/reference/Temp_Tables.html#_local_temporary_tables), Local temporary tables can be defined implicitly by referencing them in a INSERT statement or explicitly with a CREATE TABLE statement.

* An example of create local temporary tale implicitly

~~~
execute(conn, "INSERT INTO #t SELECT IntKey FROM Bqt1.Smalla", false);
execute(conn, "INSERT INTO #t VALUES(2)", false);
execute(conn, "SELECT * FROM #t", false);
~~~

> NOTE: Implicitly created temp tables must have a name that starts with `#`, the table be created in a dynamic way.

* An example of create local temporary tale explicitly

~~~
execute(conn, "CREATE LOCAL TEMPORARY TABLE TEMP (a integer)", false);
execute(conn, "SELECT IntKey INTO TEMP FROM Bqt1.Smalla", false);
execute(conn, "INSERT INTO TEMP VALUES(2)", false);
execute(conn, "SELECT * FROM TEMP", false);
~~~

> NOTE: The Explicit creatation do the same work as the implicit way above.

### The underlying of Create

![Temp table create]({{ site.baseurl }}/assets/blog/teiid/teiid-seq-temp-create.png)

The `CREATE LOCAL TEMPORARY TABLE` will create a STree Object.



## Global Temporary Tables

As per [Teiid Document](https://teiid.gitbooks.io/documents/content/reference/Temp_Tables.html#_global_temporary_tables), Global temporary tables are created in Teiid Designer or via the metadata supplied to Teiid at deploy time. Unlike local temporary tables, they cannot be created at runtime. A global temporary tables share a common definition via a schema entry, but each session has a new instance of the temporary table created upon it’s first use. The table is then dropped when the session ends. There is no explicit drop support.

### An example of Global Temporary Tables

* Create DDL in vdb

~~~
    <model name="Stocks" type="VIRTUAL">
        <metadata type="DDL"><![CDATA[
        CREATE GLOBAL TEMPORARY TABLE GTEMP (id SERIAL, name string, PRIMARY KEY (id)) OPTIONS (UPDATABLE 'true');
]]> </metadata>
    </model>
~~~

* DML Operation via JDBC

~~~
execute(conn, "INSERT INTO GTEMP (name) VALUES ('teiid')", false);
execute(conn, "INSERT INTO GTEMP (name) VALUES ('jboss')", false);
execute(conn, "SELECT * FROM GTEMP", false);
execute(conn, "UPDATE GTEMP SET name = 'teiid to jdv' WHERE id =1", false);
execute(conn, "UPDATE GTEMP SET name = 'jboss by redhat' WHERE id =2", false);
execute(conn, "SELECT * FROM GTEMP", false);
~~~

