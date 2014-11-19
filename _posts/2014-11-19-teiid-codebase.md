---
layout: blog
title:  "Teiid Code Overview"
date:   2014-11-19 18:35:00
categories: teiid
permalink: /teiid-code
author: Kylin Soong
duoshuoid: ksoong20141119
---

[Teiid](https://github.com/teiid/teiid) is the codebase for teiid project, primary purpose of this article is give a overview of Teiid Codebase.

## [ConnectorWork](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/dqp/internal/datamgr/ConnectorWork.java)

This is a internal used interface, but it's critical in Teiid Engine, it defined methods as below figure to operate `Teiid Connectors` layer.

![teiid connector work]({{ site.baseurl }}/assets/blog/ConnectorWork.gif)

[ConnectorWorkItem](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/dqp/internal/datamgr/ConnectorWorkItem.java) implements [ConnectorWork](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/dqp/internal/datamgr/ConnectorWork.java), we will look into it's method's logic:

### execute()

Its main function is create a translator Execution([teiid-translator-api](http://ksoong.org/teiid-translator-api/) for details), then invoke Execution's execute() method, the completed procedure like:

* Create Data Source Connection base on JCA connector implementation
* Create translator Execution with translator ExecutionFactory
* Invoke translator Execution's invoke() method


