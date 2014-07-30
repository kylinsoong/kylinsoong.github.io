---
layout: blog
title:  "Example of Dynamic Data Federation"
date:   2014-07-27 17:57:12
categories: Teiid
author: Kylin Soong
---

Primary purpose of this document supply a sample for federate 2 data source via JBoss Data Virtualization products.

## Overview

The [dynamicvdb-datafederation](https://github.com/teiid/teiid-quickstarts/tree/master/dynamicvdb-datafederation) quickstart demonstrate the ability of Data Virtualization to integrate multiple datasources so that a single query can return results from one or more of those sources. This article give the detailed steps to understand and runt the dynamic data federation example. Specifically, we split the example to 3 stages:

* Run Marketdata VDB
* Run Account VDB
* Run Federation VDB

## Requirements

* JBoss Data Virtualization 6.x 

> JBoss Data Virtualization 6.x installed and configured correctly, refer to [document](../installation/jdv-installation.md) for details

* [marketdata.csv](../metadata/marketdata.csv)

> [marketdata.csv](../metadata/marketdata.csv) should be copied to a location, eg /home/kylin/project/teiid-designer-samples/metadata

* [customer-schema.sql](../metadata/customer-schema.sql)

> [customer-schema.sql](../metadata/customer-schema.sql) should be executed against a exist mysql database

* For install, configure, setup Mysql refer to [mysql quick document](../metadata/mysql-usage-scripts.md)

## Run Marketdata VDB

As below figure:

![Market Data VDB]({{ site.url }}/assets/marketdata.png)

Market Data (Stock prices), stored in a CSV text file. The Marketdata VDB define a model for the data source. The VDB will be deployed to the JBoss Data Virtualization Runtime, thereby, making it accessible to the user application using JDBC. 

### Install Resource Adapter

Either use the following CLI commands:

~~~
/subsystem=resource-adapters/resource-adapter=filemarketdata:add(module=org.jboss.teiid.resource-adapter.file)
subsystem=resource-adapters/resource-adapter=filemarketdata/connection-definitions=fileDS:add(jndi-name=java:/marketdata-file, class-name=org.teiid.resource.adapter.file.FileManagedConnectionFactory, enabled=true, use-java-context=true)
/subsystem=resource-adapters/resource-adapter=filemarketdata/connection-definitions=fileDS/config-properties=ParentDirectory:add(value=/home/kylin/project/teiid-designer-samples/metadata)
/subsystem=resource-adapters/resource-adapter=filemarketdata/connection-definitions=fileDS/config-properties=AllowParentPaths:add(value=true)
/subsystem=resource-adapters/resource-adapter=filemarketdata:activate
/:reload
~~~

Or, just edit the `standalone.xml` in subsystem `urn:jboss:domain:resource-adapters:1.1`, add the following:

~~~
                <resource-adapter id="filemarketdata">
                    <module slot="main" id="org.jboss.teiid.resource-adapter.file"/>
                    <connection-definitions>
                        <connection-definition class-name="org.teiid.resource.adapter.file.FileManagedConnectionFactory" jndi-name="java:/marketdata-file" enabled="true" use-java-context="true" pool-name="fileDS">
                            <config-property name="ParentDirectory">
                                /home/kylin/project/teiid-designer-samples/metadata
                            </config-property>
                            <config-property name="AllowParentPaths">
                                true
                            </config-property>
                        </connection-definition>
                    </connection-definitions>
                </resource-adapter>
~~~

### Deploy VDB

Copy both [marketdata-vdb.xml](marketdata-vdb.xml) and [marketdata-vdb.xml.dodeploy](marketdata-vdb.xml.dodeploy) to JDV_HOME/standalone/deployments, note the following line log hint it deployed success.

~~~
13:44:58,634 INFO  [org.teiid.RUNTIME] (teiid-async-threads - 4) TEIID40003 VDB Marketdata.1 is set to ACTIVE
~~~

### Test VDB

Run [**MarketdataClient**](../jdbc-client/src/main/java/com/jboss/teiid/client/MarketdataClient.java) as java Application, it will query VDB via SQL `SELECT * FROM Marketdata`, the console output like:

~~~
Query SQL: SELECT * FROM Marketdata
1: RHT, 30.00
2: BA, 42.75
3: MON, 78.75
4: PNRA, 84.97
5: SY, 24.30
6: BTU, 41.25
7: IBM, 80.89
8: DELL, 10.75
9: HPQ, 31.52
10: GE, 16.45
~~~

## Run Account VDB

As below figure:

![Account Data VDB]({{ site.url }}/assets/account.png)

Account Information, stored in Mysql database which is referenced as the accounts-ds data source in the Data Virtualization server, The VDB, which call Account, will define a model for the data source, it will be deployed to the JBoss Data Virtualization Runtime, thereby, making it accessible to the user application using JDBC.

### Setup Data Source

We have executed [customer-schema.sql](../metadata/customer-schema.sql) against a exist database, it looks

| *Database* | *Username* | *Password* |
|------------|------------|------------|
|customer |jdv_user |jdv_pass |

We also can setup datasource via CLI commands ot edit the configuration file, refer to [this document](../metadata/mysql-datasource-install.md) for details

### Deploy VDB

Copy both [account-vdb.xml](account-vdb.xml) and [account-vdb.xml.dodeploy](account-vdb.xml.dodeploy) to JDV_HOME/standalone/deployments, note the following line log hint it deployed success.

~~~
14:01:30,101 INFO  [org.teiid.RUNTIME] (teiid-async-threads - 2) TEIID40003 VDB Account.1 is set to ACTIVE
~~~

### Test VDB

Run [**AccountClient**](../jdbc-client/src/main/java/com/jboss/teiid/client/AccountClient.java) as java Application, it will query VDB via SQL `SELECT * FROM Stock`, the console output like:

~~~
Query SQL: SELECT * FROM Stock
1: 1010, HPQ, Hewlett-Packard Company
2: 1011, GTW, Gateway, Incorporated
3: 1012, GE, General Electric Company
4: 1013, MRK, Merck and Company Incorporated
5: 1014, DIS, Walt Disney Company
6: 1015, MCD, McDonalds Corporation
7: 1016, DOW, Dow Chemical Company
8: 1018, GM, General Motors Corporation
9: 1024, SBGI, Sinclair Broadcast Group Incorporated
10: 1025, COLM, Columbia Sportsware Company
11: 1026, COLB, Columbia Banking System Incorporated
~~~

## Run Federation VDB

As below figure:

![Federation VDB]({{ site.url }}/assets/portfolio.png)

We will base above `Run Marketdata VDB` and `Run Account VDB`, Market Data (Stock prices), stored in a CSV text file, Account Information, stored in Mysql database which is referenced as the accounts-ds data source in the Data Virtualization server, the VDB which called Portfolio, it have 2 models for each data source, Account and Marketdata, respectively. The VDB will be deployed to the Teiid Runtime, thereby, making it accessible to the user application using JDBC. 

Due to the Run Federation VDB base on above `Run Marketdata VDB` and `Run Account VDB`, so we don't need either install resource adapter, or setup datasource, we start from deply VDB.

### Deploy VDB

Copy both [portfolio-vdb.xml](portfolio-vdb.xml) and [portfolio-vdb.xml.dodeploy](portfolio-vdb.xml.dodeploy) to JDV_HOME/standalone/deployments, note the following line log hint it deployed success.

~~~
14:20:05,709 INFO  [org.teiid.RUNTIME] (teiid-async-threads - 4) TEIID40003 VDB Portfolio.1 is set to ACTIVE
~~~

### Test VDB

Run [**PortfolioClient**](../jdbc-client/src/main/java/com/jboss/teiid/client/PortfolioClient.java) as java Application, the console output like:

~~~
Query SQL: SELECT * FROM Marketdata
1: RHT, 30.00
2: BA, 42.75
3: MON, 78.75
4: PNRA, 84.97
5: SY, 24.30
6: BTU, 41.25
7: IBM, 80.89
8: DELL, 10.75
9: HPQ, 31.52
10: GE, 16.45

Query SQL: SELECT * FROM PRODUCT
1: 1010, HPQ, Hewlett-Packard Company
2: 1011, GTW, Gateway, Incorporated
3: 1012, GE, General Electric Company
4: 1013, MRK, Merck and Company Incorporated
5: 1014, DIS, Walt Disney Company
6: 1015, MCD, McDonalds Corporation
7: 1016, DOW, Dow Chemical Company
8: 1018, GM, General Motors Corporation
9: 1024, SBGI, Sinclair Broadcast Group Incorporated
10: 1025, COLM, Columbia Sportsware Company
11: 1026, COLB, Columbia Banking System Incorporated

Query SQL: SELECT A.* FROM (EXEC MarketData.getTextFiles('marketdata.csv')) AS f, TEXTTABLE(f.file COLUMNS SYMBOL string, PRICE bigdecimal HEADER) AS A
1: RHT, 30.00
2: BA, 42.75
3: MON, 78.75
4: PNRA, 84.97
5: SY, 24.30
6: BTU, 41.25
7: IBM, 80.89
8: DELL, 10.75
9: HPQ, 31.52
10: GE, 16.45

Query SQL: SELECT * FROM Stock
1: 1012, GE, 16.45, General Electric Company
2: 1010, HPQ, 31.52, Hewlett-Packard Company

Query SQL: select product.symbol, stock.price, company_name from product, (EXEC MarketData.getTextFiles('marketdata.csv')) f, TEXTTABLE(f.file COLUMNS symbol string, price bigdecimal HEADER) stock where product.symbol=stock.symbol
1: HPQ, 31.52, Hewlett-Packard Company
2: GE, 16.45, General Electric Company

Query SQL: SELECT A.ID, S.symbol, S.price, A.COMPANY_NAME FROM Marketdata AS S, PRODUCT AS A WHERE S.symbol = A.SYMBOL
1: 1012, GE, 16.45, General Electric Company
2: 1010, HPQ, 31.52, Hewlett-Packard Company
~~~
