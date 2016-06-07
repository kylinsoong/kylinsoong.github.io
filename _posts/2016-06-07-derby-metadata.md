---
layout: blog
title:  "Derby Metadata"
date:   2016-06-07 18:40:12
categories: database
permalink: /derby-meta
author: Kylin Soong
duoshuoid: ksoong2016060701
excerpt: Apache Derby, DatabaseMetaData, Data Length, Data Size
---

* Table of contents
{:toc}

## System Tables

### List all tables

~~~
DatabaseMetaData dmd = conn.getMetaData();
ResultSet rs = dmd.getSchemas();
List<String> schemas = new ArrayList<String>();
while (rs.next()) {
    schemas.add(rs.getString(1));
}
rs.close();
        
for(String schema : schemas) {
    rs = dmd.getTables(null, schema, "%", null);
    while (rs.next()){
        System.out.println(rs.getObject(2) + ", " + rs.getObject(3) + ", " + rs.getObject(4));
    }
}
~~~

The list of system tables:

~~~
SYS, SYSALIASES, SYSTEM TABLE
SYS, SYSCHECKS, SYSTEM TABLE
SYS, SYSCOLPERMS, SYSTEM TABLE
SYS, SYSCOLUMNS, SYSTEM TABLE
SYS, SYSCONGLOMERATES, SYSTEM TABLE
SYS, SYSCONSTRAINTS, SYSTEM TABLE
SYS, SYSDEPENDS, SYSTEM TABLE
SYS, SYSFILES, SYSTEM TABLE
SYS, SYSFOREIGNKEYS, SYSTEM TABLE
SYS, SYSKEYS, SYSTEM TABLE
SYS, SYSPERMS, SYSTEM TABLE
SYS, SYSROLES, SYSTEM TABLE
SYS, SYSROUTINEPERMS, SYSTEM TABLE
SYS, SYSSCHEMAS, SYSTEM TABLE
SYS, SYSSEQUENCES, SYSTEM TABLE
SYS, SYSSTATEMENTS, SYSTEM TABLE
SYS, SYSSTATISTICS, SYSTEM TABLE
SYS, SYSTABLEPERMS, SYSTEM TABLE
SYS, SYSTABLES, SYSTEM TABLE
SYS, SYSTRIGGERS, SYSTEM TABLE
SYS, SYSUSERS, SYSTEM TABLE
SYS, SYSVIEWS, SYSTEM TABLE
SYSIBM, SYSDUMMY1, SYSTEM TABLE
~~~

[View completed contents of all system tables]({{ site.baseurl }}/assets/download/derby-metadata-tables)

### Query row/column size

In this section, we use the table `DESERIALIZETEST`, the create DDL as below

~~~
// From https://db.apache.org/derby/docs/10.12/ref/rrefsqlj13733.html
// length is an unsigned integer literal designating the length in bytes. The default length for a CHAR is 1
// one column size is 32 bytes, (1 << 5) or (2 ^ 5)
// one row(8 columns) size 256 bytes, (1 << 8) or (2 ^ 8) 
public static final String TABEL_CREATE = "CREATE TABLE DESERIALIZETEST (COL_A CHAR(32), COL_B CHAR(32), COL_C CHAR(32), COL_D CHAR(32), COL_E CHAR(32), COL_F CHAR(32), COL_G CHAR(32), COL_H CHAR(32))";
~~~

* Query Row Count 

~~~
SELECT COUNT(COL_A) FROM DESERIALIZETEST
~~~

* Query Column Size

~~~
SELECT SUM(LENGTH(COL_A)) AS COL_A_SIZE from DESERIALIZETEST
~~~

![Query Column Size]({{ site.baseurl }}/assets/blog/database/derby-table-column-size.png)
