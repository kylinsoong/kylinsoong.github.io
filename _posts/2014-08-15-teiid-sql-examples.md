---
layout: blog
title:  "Teiid SQL Support Samples"
date:   2014-08-15 17:57:12
categories: teiid
author: Kylin Soong
duoshuoid: ksoong20140815
excerpt: Examples for show how SQL-92 DML and SQL-99 support in Teiid
---

* Table of contents
{:toc}

## DML

### UNION combine the results

~~~
SELECT VDBName, SchemaName, Name, TargetSchemaName, TargetName, Valid, LoadState, Updated, Cardinality FROM SYSADMIN.MatViews
UNION 
SELECT VDBName, SchemaName, Name, TargetSchemaName, TargetName, Valid, LoadState, Updated, Cardinality FROM status 
UNION 
SELECT VDBName, SchemaName, Name, TargetSchemaName, TargetName, Valid, LoadState, Updated, Cardinality FROM status_1
~~~

[UNION Syntax Rules](https://teiid.gitbooks.io/documents/content/reference/Set_Operations.html)

### SELECT with TABLE function

~~~
SELECT M.VDBName, M.SchemaName, M.Name, S.TargetSchemaName, S.TargetName, S.Valid, S.LoadState, S.Updated, S.Cardinality FROM SYSADMIN.MatViews AS M, TABLE(CALL SYSADMIN.matViewStatus(M.SchemaName, M.Name)) AS S
~~~ 
