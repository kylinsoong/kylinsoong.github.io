---
layout: blog
title:  "Teiid Language API"
date:   2014-08-19 17:20:12
categories: teiid
permalink: /teiid-language-api
author: Kylin Soong
duoshuoid: ksoong20140819
---

This document introduce the Teiid language API with UML diagram and Junit Test code.

## Hierarchy Architecture

All these class under package [org.teiid.language](https://github.com/teiid/teiid/tree/master/api/src/main/java/org/teiid/language): 

* `LanguageObject` is the root interface for all language object interfaces
* The bold entity are interface

~~~
**LanguageObject**
├── BaseLanguageObject
│   ├── Argument
│   ├── BatchedUpdates
│   ├── Call
│   ├── ColumnReference
│   ├── Condition
│   │   ├── AndOr
│   │   ├── BaseInCondition
│   │   │   ├── In
│   │   │   └── SubqueryIn
│   │   ├── Comparison
│   │   ├── Exists
│   │   ├── IsNull
│   │   ├── Like
│   │   ├── Not
│   │   └── SubqueryComparison
│   ├── Delete
│   ├── DerivedColumn
│   ├── DerivedTable
│   ├── ExpressionValueSource
│   ├── Function
│   │   └── AggregateFunction
│   ├── GroupBy
│   ├── Insert
│   ├── Join
│   ├── Limit
│   ├── Literal
│   ├── NamedTable
│   ├── OrderBy
│   ├── Parameter
│   ├── QueryExpression
│   │   ├── Select
│   │   └── SetQuery
│   ├── ScalarSubquery
│   ├── SearchedCase
│   ├── SearchedWhenClause
│   ├── SetClause
│   ├── SortSpecification
│   ├── Update
│   ├── WindowFunction
│   ├── WindowSpecification
│   ├── With
│   └── WithItem
├── **Command**
│   ├── BatchedUpdates
│   ├── Call
│   ├── QueryExpression
│   │   ├── Select
│   │   └── SetQuery
│   └── **BatchedCommand**
│       ├── Delete
│       ├── Insert
│       └── Update
├── **Expression**
│   ├── Array
│   ├── ColumnReference
│   ├── Condition
│   │   ├── AndOr
│   │   ├── BaseInCondition
│   │   │   ├── In
│   │   │   └── SubqueryIn
│   │   ├── Comparison
│   │   ├── Exists
│   │   ├── IsNull
│   │   ├── Like
│   │   ├── Not
│   │   └── SubqueryComparison
│   ├── Function
│   │   └── AggregateFunction
│   ├── Literal
│   ├── Parameter
│   ├── ScalarSubquery
│   ├── SearchedCase
│   └── WindowFunction
├── **InsertValueSource**
│   ├── ExpressionValueSource
│   └── QueryExpression
│       ├── Select
│       └── SetQuery
└── **TableReference**
    ├── DerivedTable
    ├── Join
    └── NamedTable
~~~

### org.teiid.language.Call

![Teiid Language API Call]({{ site.baseurl }}/assets/blog/Call.gif)

* The `Call` represents a procedural execution (such as a stored procedure).
* The `LanguageObject` is root interface for all language object interfaces.
* The `MetadataReference` used to mark language objects as having a reference to a MetadataID. 
* The `Command` represents a command in the language objects. A command is an instruction of something to execute sent to the connector. Typical commands perform SELECT, INSERT, UPDATE, DELETE, etc type operations.

### org.teiid.language.Argument

![Teiid Language API Argument]({{ site.baseurl }}/assets/blog/Argument.gif)

A Junit code snippets for using above API:

~~~
	@Test
	public void testCall() {
		
		Literal literal = new Literal("marketdata.csv", TypeFacility.RUNTIME_TYPES.STRING);
		Argument argument = new Argument(Direction.IN, literal, TypeFacility.RUNTIME_TYPES.STRING, null);
		Call call = LanguageFactory.INSTANCE.createCall("getTextFiles", Arrays.asList(argument), null);
		assertEquals("getTextFiles", call.getProcedureName());
		assertNotNull(call.getArguments());
	}
~~~

### org.teiid.language.visitor.LanguageObjectVisitor
