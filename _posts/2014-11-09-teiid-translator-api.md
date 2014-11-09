---
layout: blog
title:  "Teiid Translator API"
date:   2014-11-09 17:20:12
categories: teiid
permalink: /teiid-translator-api
author: Kylin Soong
duoshuoid: ksoong2014110901
---

Teiid Translator API under package `org.teiid.translator`, it can be quick viewed from [https://github.com/teiid/teiid/tree/master/api/src/main/java/org/teiid/translator](https://github.com/teiid/teiid/tree/master/api/src/main/java/org/teiid/translator), the purpose of this article is for giving a high level overview of Teiid Translator API.

### Execution interface

![Execution interface]({{ site.baseurl }}/assets/blog/Execution.gif)

An execution represents the state and lifecycle for a particular command execution. The methods provided on this interface define standard lifecycle methods. `Execution` has define 3 methods:

* close() - When execution completes, the close() will be called, the execution be terminated normally.
* cancel() - If execution must be aborted, due to user or administrator action, the cancel() will be called, the execution be canceled normally. This will happen via a different thread from the one performing the execution, so should be expected to happen in a multi-threaded scenario.
* execute() - Execute the associated command.  Results will be retrieved through a specific sub-interface call.

The `ResultSetExecution` defines an execution for `QueryExpression` and `Call` that returns a resultset, which is represented through the iterator method next(). 

* next() - Retrieves the next row of the resultset. 

The `ProcedureExecution` represents the case where a connector can execute a `Call`. The output may include 0 or more output parameters and optionally a result set. It define one method:

* getOutputParameterValues() - Get the output parameter values.  Results should place the return parameter first if it is present, then the IN/OUT and OUT parameters should follow in the order they appeared in the command.

The `ReusableExecution` extends `Execution` and additional methods that may optionally be implemented for an `Execution`, it has 2 methods:

* reset(Command c, ExecutionContext executionContext, C connection) - Called to reinitialized the execution for use.
* dispose() - Called when the execution is no longer used.

The `UpdateExecution` represents the case where a connector can execute an `Insert`, `Update`, `Delete` or `BatchedUpdates` command, it extends `Execution` and one additional method:

* getUpdateCounts() - Returns the update counts for the execution.



