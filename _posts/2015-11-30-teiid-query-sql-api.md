---
layout: blog
title:  "Teiid Query Sql API"
date:   2015-11-30 12:10:00
categories: teiid
permalink: /teiid-query-sql-api
author: Kylin Soong
duoshuoid: ksoong2015113001
excerpt: UML and examples of Teiid Query SQL API
---

## Criteria

![UML of Criteria]({{ site.baseurl }}/assets/blog/teiid-uml-criteria.png)

The `org.teiid.query.sql.lang.Criteria` represents the criteria clause for a query, which defines constraints on the data values to be retrieved for each parameter in the select clause.

## Command

![UML of Command]({{ site.baseurl }}/assets/blog/teiid-uml-sql-command.png)

A Command is an interface for all the language objects that are at the root of a language object tree representing a SQL statement.  For instance, a Query command represents a SQL select query, an Update command represents a SQL update statement, etc.

## LanguageObject

![UML of LanguageObject]({{ site.baseurl }}/assets/blog/teiid-uml-sql-other.png)

## ProcessorPlan

![UML of ProcessorPlan]({{ site.baseurl }}/assets/blog/teiid-uml-processorPlan.png)

* ProcessorPlan represents a processor plan. It is generic in that it abstracts the interface to the plan by the processor, meaning that the actual implementation of the plan or the types of processing done by the plan is not important to the processor.
