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
* `LanguageObject`, `Command`, `BatchedCommand`, `Expression`, `InsertValueSource`, `TableReference` are interfaces
* `BaseLanguageObject` is abstract class for all language objects, all these language objects implement reference above interface 

~~~
LanguageObject
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
├── Command
│   ├── BatchedUpdates
│   ├── Call
│   ├── QueryExpression
│   │   ├── Select
│   │   └── SetQuery
│   └── BatchedCommand
│       ├── Delete
│       ├── Insert
│       └── Update
├── Expression
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
├── InsertValueSource
│   ├── ExpressionValueSource
│   └── QueryExpression
│       ├── Select
│       └── SetQuery
└── TableReference
    ├── DerivedTable
    ├── Join
    └── NamedTable
~~~

### org.teiid.language.MetadataReference

The Interface `MetadataReference` only define one method:

~~~
public interface MetadataReference<T extends AbstractMetadataRecord> {
    T getMetadataObject();   
}
~~~

This interface is used to mark language objects as having a reference to a MetadataID. There are some language objects implement the `MetadataReference`, the Hierarchy Architecture as below:

~~~
MetadataReference
├── Argument
├── Call
├── ColumnReference
├── Function
│   └── AggregateFunction
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

## org.teiid.language.visitor.LanguageObjectVisitor

As above Hierarchy Tree, `LanguageObject` is the root interface, it only define one method:

~~~
public interface LanguageObject {
    void acceptVisitor(LanguageObjectVisitor visitor);
}
~~~ 

Which enbles all language objects accept Visitor, this method referred a parameter `LanguageObjectVisitor`, it have a series method invoked by language object:

~~~
public interface LanguageObjectVisitor {
    public void visit(AggregateFunction obj);
    public void visit(BatchedUpdates obj);
    public void visit(ExpressionValueSource obj);
    public void visit(Comparison obj);
    public void visit(AndOr obj);
    public void visit(Delete obj);
    public void visit(ColumnReference obj);
    public void visit(Call obj);
    public void visit(Exists obj);
    public void visit(Function obj);
    public void visit(NamedTable obj);
    public void visit(GroupBy obj);
    public void visit(In obj);
    public void visit(DerivedTable obj);
    public void visit(Insert obj);    
    public void visit(IsNull obj);
    public void visit(Join obj);
    public void visit(Like obj);
    public void visit(Limit obj);
    public void visit(Literal obj);
    public void visit(Not obj);
    public void visit(OrderBy obj);
    public void visit(SortSpecification obj);
    public void visit(Argument obj);
    public void visit(Select obj);
    public void visit(ScalarSubquery obj);
    public void visit(SearchedCase obj);
    public void visit(DerivedColumn obj);
    public void visit(SubqueryComparison obj);
    public void visit(SubqueryIn obj);
    public void visit(Update obj);
    public void visit(SetQuery obj);
    public void visit(SetClause obj);
    public void visit(SearchedWhenClause obj);
    public void visit(With obj);
    public void visit(WithItem obj);
    public void visit(WindowFunction windowFunction);
    public void visit(WindowSpecification windowSpecification);
    public void visit(Parameter obj);
    public void visit(Array array);
}
~~~

For example, in above UML diagram section, the org.teiid.language.Call's `acceptVisitor` implementation looks:

~~~
public void acceptVisitor(LanguageObjectVisitor visitor) {
    visitor.visit(this);
}
~~~

also the org.teiid.language.Argument's `acceptVisitor` implementation looks:

~~~
public void acceptVisitor(LanguageObjectVisitor visitor) {
    visitor.visit(this);
}
~~~

Under package [org.teiid.language.visitor](https://github.com/teiid/teiid/tree/master/api/src/main/java/org/teiid/language/visitor) there are some default implementation, the Hierarchy Architecture as below:

~~~
LanguageObjectVisitor
└── AbstractLanguageVisitor
    ├── HierarchyVisitor
    │   ├── CollectorVisitor
    │   └── DelegatingHierarchyVisitor
    └── SQLStringVisitor
~~~

* **LanguageObjectVisitor** - root interface
* **AbstractLanguageVisitor** - an abstract class let the instance invoke the type-specific visit() method
* **SQLStringVisitor** - Creates a SQL string for a LanguageObject subtree. Instances of this class are not reusable, and are not thread-safe.
* **HierarchyVisitor** - Visits each node in  a hierarchy of LanguageObjects. The default implementation of each visit() method is simply to visit the children of a given LanguageObject, if any exist, with this HierarchyVisitor (without performing any actions on the node). A subclass can selectively override visit() methods to delegate the actions performed on a node to another visitor by calling that Visitor's visit() method. This implementation makes no guarantees about the order in which the children of an LanguageObject are visited
* **CollectorVisitor** - This visitor can be used to collect all objects of a certain type in a language tree.  Each visit method does an instanceof method to check whether the object is of the expected type.
* **DelegatingHierarchyVisitor** - Delegates pre- and post-processing for each node in the hierarchy to delegate visitors.
