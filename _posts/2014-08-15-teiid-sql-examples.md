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

## Scalar Functions

### String Functions

~~~
CREATE VIRTUAL PROCEDURE testStringFunction(IN x string NOT NULL, IN y string NOT NULL, IN z string NOT NULL) RETURNS integer
AS
BEGIN
    
    EXECUTE logMsg('WARN', 'org.teiid.testStringFunction', x || ' ' || y);
    EXECUTE logMsg('WARN', 'org.teiid.testStringFunction', ASCII(x));
    EXECUTE logMsg('WARN', 'org.teiid.testStringFunction', CHR(72));
    EXECUTE logMsg('WARN', 'org.teiid.testStringFunction', CHAR(72));
    EXECUTE logMsg('WARN', 'org.teiid.testStringFunction', CONCAT(x, y));
    
    EXECUTE logMsg('WARN', 'org.teiid.testStringFunction', CONCAT2(x, y));
    EXECUTE logMsg('WARN', 'org.teiid.testStringFunction', ENDSWITH('llo', x));
    EXECUTE logMsg('WARN', 'org.teiid.testStringFunction', INITCAP(z));
    EXECUTE logMsg('WARN', 'org.teiid.testStringFunction', INSERT(x, 2, 0,y));
    EXECUTE logMsg('WARN', 'org.teiid.testStringFunction', LCASE(z));
    
    EXECUTE logMsg('WARN', 'org.teiid.testStringFunction', LEFT(x, 2));
    EXECUTE logMsg('WARN', 'org.teiid.testStringFunction', LENGTH(x));
    EXECUTE logMsg('WARN', 'org.teiid.testStringFunction', LOCATE('or', y));
    EXECUTE logMsg('WARN', 'org.teiid.testStringFunction', LOCATE('or', y, 2));
    EXECUTE logMsg('WARN', 'org.teiid.testStringFunction', LPAD(x, 10));
    
    EXECUTE logMsg('WARN', 'org.teiid.testStringFunction', LPAD(x, 10, '-'));
    EXECUTE logMsg('WARN', 'org.teiid.testStringFunction', LTRIM('    123 abc   '));
    EXECUTE logMsg('WARN', 'org.teiid.testStringFunction', QUERYSTRING('path', 'value' as "&x", ' & ' as y, null as z));
    EXECUTE logMsg('WARN', 'org.teiid.testStringFunction', REPEAT(x, 3));
    EXECUTE logMsg('WARN', 'org.teiid.testStringFunction', RIGHT(x, 2));
    
    EXECUTE logMsg('WARN', 'org.teiid.testStringFunction', RPAD(x, 10));
    EXECUTE logMsg('WARN', 'org.teiid.testStringFunction', RPAD(x, 10, '-'));
    EXECUTE logMsg('WARN', 'org.teiid.testStringFunction', RTRIM('    123 abc   '));
    EXECUTE logMsg('WARN', 'org.teiid.testStringFunction', SPACE(3));
    EXECUTE logMsg('WARN', 'org.teiid.testStringFunction', SUBSTRING(x, 3));
    
    EXECUTE logMsg('WARN', 'org.teiid.testStringFunction', SUBSTRING(x FROM 3));
    EXECUTE logMsg('WARN', 'org.teiid.testStringFunction', SUBSTRING(x, 3, 2));
    EXECUTE logMsg('WARN', 'org.teiid.testStringFunction', SUBSTRING(x FROM 3 FOR 2));
    EXECUTE logMsg('WARN', 'org.teiid.testStringFunction', TRANSLATE('12345', '02340', '*****'));
    EXECUTE logMsg('WARN', 'org.teiid.testStringFunction', TRIM(',' FROM ',(''100'', ''a0''),'));
    
    EXECUTE logMsg('WARN', 'org.teiid.testStringFunction', TRIM(BOTH ',' FROM ',(''100'', ''a0''),'));
    EXECUTE logMsg('WARN', 'org.teiid.testStringFunction', UCASE(x));
    EXECUTE logMsg('WARN', 'org.teiid.testStringFunction', UNESCAPE(x || ' ' || y));
END	
~~~

## DML Commands

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

 
