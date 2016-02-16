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

* Table of contents
{:toc}

## Criteria

![UML of Criteria]({{ site.baseurl }}/assets/blog/teiid-uml-criteria.png)

The `org.teiid.query.sql.lang.Criteria` represents the criteria clause for a query, which defines constraints on the data values to be retrieved for each parameter in the select clause.

## Command

![UML of Command]({{ site.baseurl }}/assets/blog/teiid-uml-sql-command.png)

A Command is an interface for all the language objects that are at the root of a language object tree representing a SQL statement.  For instance, a Query command represents a SQL select query, an Update command represents a SQL update statement, etc.

### Example of Query

Combined with [Example of Select](#Example of Select) and [Example of From](#Example of From), the Example of Query looks

~~~
Query command = new Query();
command.setSelect(select);
command.setFrom(from);
System.out.println(command);
~~~

The output of above code:

~~~
SELECT A.ID, A.SYMBOL, A.COMPANY_NAME FROM Accounts.PRODUCT AS A
~~~

## LanguageObject

![UML of LanguageObject]({{ site.baseurl }}/assets/blog/teiid-uml-sql-other.png)

* `From` - Represents a FROM clause in a SELECT query. The from clause holds a set of FROM subclauses. Each FROM subclause can be either a single group `UnaryFromClause` or a join predicate `JoinPredicate`
* `FromClause` - A FromClause is an interface for subparts held in a FROM clause. One type of FromClause is `UnaryFromClause`, which is the more common use and represents a single group.  Another, less common type of FromClause is the `JoinPredicate` which represents a join between two FromClauses and may contain criteria.
* `org.teiid.query.sql.lang.Select` - represents the SELECT clause of a query, which defines what elements or expressions are returned from the query.

### Example of Select

~~~java
GroupSymbol group = new GroupSymbol("A", "Accounts.PRODUCT");
ElementSymbol id = new ElementSymbol("ID", group);
id.setType(DataTypeManager.DefaultDataClasses.STRING);
ElementSymbol symbol = new ElementSymbol("SYMBOL", group);
symbol.setType(DataTypeManager.DefaultDataClasses.STRING);
ElementSymbol name = new ElementSymbol("COMPANY_NAME", group);
symbol.setType(DataTypeManager.DefaultDataClasses.STRING);

Select select = new Select();
select.addSymbol(id);
select.addSymbol(symbol);
select.addSymbol(name);
~~~

### Example of From

~~~
From from = new From();
UnaryFromClause clause = new UnaryFromClause();
GroupSymbol group = new GroupSymbol("A", "Accounts.PRODUCT");
clause.setGroup(group);
from.addClause(clause);
~~~

## Symbol

![UML of Symbol]({{ site.baseurl }}/assets/blog/teiid-uml-symbol.png)

* `org.teiid.query.sql.symbol.Symbol` - This is the server's representation of a metadata symbol. The only thing a symbol has to have is a name. This name relates only to how a symbol is specified in a user's query and does not necessarily relate to any actual metadata identifier (although it may). Subclasses of this class provide specialized instances of symbol for various circumstances in a user's query. In the context of a single query, a symbol's name has a unique meaning although it may be used more than once in some circumstances.
* `org.teiid.query.sql.symbol.GroupSymbol` - This is the server's representation of a metadata group symbol. The group symbol has a name, an optional definition, and a reference to a real metadata ID. Typically, a GroupSymbol will be created only from a name and possibly a definition if the group has an alias.  The metadata ID is discovered only when resolving the query.
* `org.teiid.query.sql.symbol.ElementSymbol` - This is a subclass of Symbol representing a single element.  An ElementSymbol also is an expression and thus has a type.  Element symbols have a variety of attributes that determine how they are displayed - a flag for displaying fully qualified and an optional vdb name.

**Example of GroupSymbol**

~~~java
GroupSymbol group = new GroupSymbol("A", "Accounts.PRODUCT");
~~~

**Example of ElementSymbol**

~~~java
GroupSymbol group = new GroupSymbol("A", "Accounts.PRODUCT");
ElementSymbol id = new ElementSymbol("ID", group);
id.setType(DataTypeManager.DefaultDataClasses.STRING);
~~~

## ProcessorPlan

![UML of ProcessorPlan]({{ site.baseurl }}/assets/blog/teiid-uml-processorPlan.png)

* ProcessorPlan represents a processor plan. It is generic in that it abstracts the interface to the plan by the processor, meaning that the actual implementation of the plan or the types of processing done by the plan is not important to the processor.
