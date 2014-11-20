---
layout: blog
title:  "Teiid Code Analysis"
date:   2014-11-19 18:35:00
categories: teiid
permalink: /teiid-code
author: Kylin Soong
duoshuoid: ksoong20141119
---

[Teiid](https://github.com/teiid/teiid) is the codebase for teiid project, this article will guide you how to look over the complete Teiid code.

## Teiid Client

[Teiid JDBC Client]({{ site.baseurl }}/teiid-jdbc-client) have detailed analysis, including:

* Connecting to a Teiid Server
* How TeiidDriver create a Connection
* How a connection execute the query
* How Teiid Server handle query request

## [ConnectorWork](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/dqp/internal/datamgr/ConnectorWork.java)

Client execute JDBC query sql be convert to a `Command` object, pass it to Engine DQP Process layer as DataTierTupleSource, then translator layer is necessary for translating data as below figure:

![teiid connector logic]({{ site.baseurl }}/assets/blog/connectorworkitem.jpg)

[ConnectorWork](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/dqp/internal/datamgr/ConnectorWork.java) is a internal used interface, but it's critical in Teiid Engine, it defined methods as below figure to operate `Teiid Connectors` layer.

![teiid connector work]({{ site.baseurl }}/assets/blog/ConnectorWork.gif)

[ConnectorWorkItem](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/dqp/internal/datamgr/ConnectorWorkItem.java) implements [ConnectorWork](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/dqp/internal/datamgr/ConnectorWork.java), we will look into it's method's in the following.

For more details about Execution layer, please refer to [teiid-translator-api]({{ site.baseurl }}/teiid-translator-api)

### execute()

Its main function is create a translator Execution, then invoke Execution's execute() method, the completed procedure like:

* Create Data Source Connection base on JCA connector implementation
* Create translator Execution with translator ExecutionFactory
* Invoke translator Execution's execute() method

### more()

Usually this methods be invoked after execute(), this method will invoke Execution's next() method repeatedly, return list of rows existed in data source.
