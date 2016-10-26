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

## What is Teiid Query Sql API

As the overview section of [Understanding Teiid Engine](http://ksoong.org/teiid-dqp#overview), Teiid query sql api can be categorized into 6 sections:

* lang
* proc
* symbol
* navigator
* visitor
* util

This article will focus on the Teiid Query Sql API, like the key interface [LanguageObject](#languageobject), [LanguageVisitor](#languagevisitor), etc

All the api discribed in this article are under `org.teiid.query.sql` and it's sub package:

~~~
org.teiid.query.sql
org.teiid.query.sql.lang
org.teiid.query.sql.proc
org.teiid.query.sql.symbol
org.teiid.query.sql.navigator
org.teiid.query.sql.visitor
org.teiid.query.sql.til
~~~

## LanguageObject

`org.teiid.query.sql.LanguageObject` is the primary interface for all language objects(There mainly 2 kinds of language objects: language objects, symbol objects, procedure language objects). The LanguageObject extends the `java.lang.Cloneable` and define a `acceptVisitor` method for the language object to call back on the visitor.

~~~
void acceptVisitor(LanguageVisitor visitor);
~~~

### Language objects

Language objects are too complex, we split into 3 sections: Command, Criteria, From Clause and others.

#### Command

![UML of Command]({{ site.baseurl }}/assets/blog/teiid-uml-sql-command.png)

A Command is an interface for all the language objects that are at the root of a language object tree representing a SQL statement.  For instance, a Query command represents a SQL select query, an Update command represents a SQL update statement, etc.

##### Commands categories

There are more than 15 categories as below:

~~~
TYPE_UNKNOWN
TYPE_QUERY
TYPE_INSERT
TYPE_UPDATE
TYPE_DELETE
TYPE_STORED_PROCEDURE
TYPE_UPDATE_PROCEDURE
TYPE_BATCHED_UPDATE
TYPE_DYNAMIC
TYPE_CREATE
TYPE_DROP
TYPE_TRIGGER_ACTION
TYPE_ALTER_VIEW
TYPE_ALTER_PROC
TYPE_ALTER_TRIGGER
~~~

#### Criteria

![UML of Criteria]({{ site.baseurl }}/assets/blog/teiid-uml-criteria.png)

The `org.teiid.query.sql.lang.Criteria` represents the criteria clause for a query, which defines constraints on the data values to be retrieved for each parameter in the select clause.


#### From Clause and others

![UML of LanguageObject]({{ site.baseurl }}/assets/blog/teiid-uml-sql-other.png)

* `From` - Represents a FROM clause in a SELECT query. The from clause holds a set of FROM subclauses. Each FROM subclause can be either a single group `UnaryFromClause` or a join predicate `JoinPredicate`
* `FromClause` - A FromClause is an interface for subparts held in a FROM clause. One type of FromClause is `UnaryFromClause`, which is the more common use and represents a single group.  Another, less common type of FromClause is the `JoinPredicate` which represents a join between two FromClauses and may contain criteria.
* `org.teiid.query.sql.lang.Select` - represents the SELECT clause of a query, which defines what elements or expressions are returned from the query.

#### Examples

##### Example - Select columns

~~~
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

System.out.println(select);
~~~

Run above code will output

~~~
 A.ID, A.SYMBOL, A.COMPANY_NAME
~~~

##### Example - Select functions

~~~
Constant constant = new Constant(1900000000, DataTypeManager.DefaultDataClasses.INTEGER);
Function function = new Function("FROM_UNIXTIME",  new Expression[]{constant});
ExpressionSymbol symbol = new ExpressionSymbol("expr1", function);      
Select select = new Select();
select.addSymbol(symbol);     
System.out.println(select);
~~~

Run above code will output

~~~
FROM_UNIXTIME(1900000000)
~~~

##### Example - From

~~~
From from = new From();
UnaryFromClause clause = new UnaryFromClause();
GroupSymbol group = new GroupSymbol("A", "Accounts.PRODUCT");
clause.setGroup(group);
from.addClause(clause);

System.out.println(from);
~~~

Run above code will output

~~~
FROM Accounts.PRODUCT AS A
~~~

##### Example - Query

~~~
GroupSymbol group = new GroupSymbol("A", "Accounts.PRODUCT");
ElementSymbol id = new ElementSymbol("ID", group, String.class);
ElementSymbol symbol = new ElementSymbol("SYMBOL", group, String.class);
ElementSymbol name = new ElementSymbol("COMPANY_NAME", group, String.class);

List<ElementSymbol> symbols = Arrays.asList(id, symbol, name);
Select select = new Select(symbols);

From from = new From();
UnaryFromClause clause = new UnaryFromClause();
clause.setGroup(group);
from.addClause(clause);

Query command = new Query();
command.setSelect(select);
command.setFrom(from);
System.out.println(command);
~~~

Run above code will output

~~~
SELECT A.ID, A.SYMBOL, A.COMPANY_NAME FROM Accounts.PRODUCT AS A
~~~

##### Example - QueryParser to Command

~~~
import org.teiid.query.parser.QueryParser;
import org.teiid.query.sql.lang.Command;

String sql = "select from_unixtime(x.e2) from pm1.g1 as x";
Command command = QueryParser.getQueryParser().parseCommand(sql);
System.out.println(command);
~~~

Run above code will output

~~~
SELECT from_unixtime(x.e2) FROM pm1.g1 AS x
~~~

> NOTE: QueryParser will parse a SQL String to a language Command Object, this also the first step of Teiid Query Engine process client request.

##### Example - QueryParser to Criteria

~~~
import org.teiid.query.parser.QueryParser;
import org.teiid.query.sql.lang.Criteria;

String critStr = "timestampadd(SQL_TSI_SECOND, pm1.g1.e2, {ts'1970-01-01 08:00:00.0'}) = {ts'1992-12-01 07:00:00.0'}";
Criteria crit = QueryParser.getQueryParser().parseCriteria(critStr);
System.out.println(crit);
~~~

Run above code will output

~~~
timestampadd(SQL_TSI_SECOND, pm1.g1.e2, {ts'1970-01-01 08:00:00.0'}) = {ts'1992-12-01 07:00:00.0'}
~~~

> NOTE: QueryParser will parse a SQL String to a language CompareCriteria Object, this also the first step of Teiid Query Engine process client request.

### Symbol objects

![Teiid Query API Symbol objects]({{ site.baseurl }}/assets/blog/teiid/teiid-query-api-lang-symbol.png)

* The `Expression` is the interface for an expression in a SQL string. Expressions can be of several types (see subclasses), but all expressions have a type.  These types are used for type checking.
* The `Symbol` is the server's representation of a metadata symbol.  The only thing a symbol has to have is a name.  This name relates only to how a symbol is specified in a user's query and does not necessarily relate to any actual metadata identifier (although it may).  Subclasses of this class provide specialized instances of symbol for various circumstances in a user's query.  In the context of a single query, a symbol's name has a unique meaning although it may be used more than once in some circumstances.
* `org.teiid.query.sql.symbol.GroupSymbol` - This is the server's representation of a metadata group symbol. The group symbol has a name, an optional definition, and a reference to a real metadata ID. Typically, a GroupSymbol will be created only from a name and possibly a definition if the group has an alias.  The metadata ID is discovered only when resolving the query.
* `org.teiid.query.sql.symbol.ElementSymbol` - This is a subclass of Symbol representing a single element.  An ElementSymbol also is an expression and thus has a type.  Element symbols have a variety of attributes that determine how they are displayed - a flag for displaying fully qualified and an optional vdb name.

#### Examples

##### Example - GroupSymbol

~~~
GroupSymbol a = new GroupSymbol("A", "Accounts.PRODUCT");
GroupSymbol b = new GroupSymbol("A");
GroupSymbol c = new GroupSymbol("Accounts.A");
~~~

##### Example - ElementSymbol

~~~
GroupSymbol group = new GroupSymbol("A", "Accounts.PRODUCT");
ElementSymbol id = new ElementSymbol("ID", group);
id.setType(DataTypeManager.DefaultDataClasses.STRING);
~~~

##### Example - Constant Expression

~~~
Constant c1 = new Constant("Hello Wolrd");
Constant c2 = new Constant(10000L);
Constant c3 = new Constant(null);
constant c4 = new Constant(null, DataTypeManager.DefaultDataClasses.STRING);

System.out.println(c1.getValue());
System.out.println(c2.getType());
System.out.println(c3.isNull());
~~~

##### Example - Function(from_unixtime) Expression

~~~
Function function = new Function("FROM_UNIXTIME",  new Expression[]{new Constant(1900000000)});
System.out.println(function);
~~~

##### Example - Function(timestampadd) Expression

~~~
String name = FunctionLibrary.TIMESTAMPADD;
Constant arg0 = new Constant(NonReserved.SQL_TSI_SECOND);
Constant arg1 = new Constant(1900000000, DataTypeManager.DefaultDataClasses.INTEGER);
Constant arg2 = new Constant(new Timestamp(0));
Function timestampadd = new Function(name, new Expression[] {arg0, arg1, arg2});
System.out.println(timestampadd);
~~~

run above code output

~~~
timestampadd(SQL_TSI_SECOND, 1900000000, {ts'1970-01-01 08:00:00.0'})
~~~

##### Example - ExpressionSymbol, Function, Constant

~~~
Constant constant = new Constant(1900000000, DataTypeManager.DefaultDataClasses.INTEGER);
Function function = new Function("FROM_UNIXTIME",  new Expression[]{constant});
ExpressionSymbol symbol = new ExpressionSymbol("expr1", function);
System.out.println(symbol);
~~~

### Procedure language objects

![Teiid Query API Procedure language objects]({{ site.baseurl }}/assets/blog/teiid/teiid-query-api-sql-lang-proc.png)

* The `Statement` represents the a statement in the stored procedure language. The subclasses of this class represent specific statements like: IfStatement, AssignmentStatement, ReturnStatement, LoopStatement, WhileStatement, etc.

## LanguageVisitor

`org.teiid.query.sql.LanguageVisitor` is one of key api of teiid query sql api. The LanguageVisitor can be used to visit a LanguageObject as if it were a tree and perform some action on some or all of the language objects that are visited. The LanguageVisitor is extended to create a concrete visitor and some or all of the public visit methods should be overridden to provide the visitor functionality. These public visit methods SHOULD NOT be called directly.

**The public visit methods supplies by LanguageVisitor**

~~~
// Visitor methods for language objects
visit(BatchedUpdateCommand obj)
visit(BetweenCriteria obj)
visit(CaseExpression obj)
visit(CompareCriteria obj)
visit(CompoundCriteria obj)
visit(Delete obj)
visit(ExistsCriteria obj)
visit(From obj)
visit(GroupBy obj)
visit(Insert obj)
visit(IsNullCriteria obj)
visit(JoinPredicate obj)
visit(JoinType obj)
visit(Limit obj)
visit(MatchCriteria obj)
visit(NotCriteria obj)
visit(Option obj)
visit(OrderBy obj)
visit(Query obj)
visit(SearchedCaseExpression obj)
visit(Select obj)
visit(SetCriteria obj)
visit(SetQuery obj)
visit(StoredProcedure obj)
visit(SubqueryCompareCriteria obj)
visit(SubqueryFromClause obj)
visit(SubquerySetCriteria obj)
visit(UnaryFromClause obj)
visit(Update obj)
visit(Into obj)
visit(DependentSetCriteria obj)
visit(Create obj)
visit(Drop obj)

// Visitor methods for symbol objects
visit(AggregateSymbol obj)
visit(AliasSymbol obj)
visit(MultipleElementSymbol obj)
visit(Constant obj)
visit(ElementSymbol obj)
visit(ExpressionSymbol obj)
visit(Function obj)
visit(GroupSymbol obj)
visit(Reference obj)
visit(ScalarSubquery obj)
    
// Visitor methods for procedure language objects    
visit(AssignmentStatement obj)
visit(Block obj)
visit(CommandStatement obj)
visit(CreateProcedureCommand obj)
visit(DeclareStatement obj)    
visit(IfStatement obj)
visit(RaiseStatement obj)
visit(BranchingStatement obj)
visit(WhileStatement obj)
visit(LoopStatement obj)
visit(DynamicCommand obj)
visit(ProcedureContainer obj)
visit(SetClauseList obj)
visit(SetClause obj)
visit(OrderByItem obj)
visit(XMLElement obj)
visit(XMLAttributes obj)
visit(XMLForest obj)
visit(XMLNamespaces obj)
visit(TextTable obj)
visit(TextLine obj)
visit(XMLTable obj)
visit(DerivedColumn obj)
visit(XMLSerialize obj)
visit(XMLQuery obj)
visit(QueryString obj)
visit(XMLParse obj)
visit(ExpressionCriteria obj)
visit(WithQueryCommand obj)
visit(TriggerAction obj)
visit(ArrayTable obj)
visit(AlterView obj)
visit(AlterProcedure obj)
visit(AlterTrigger obj)
visit(WindowFunction windowFunction)
visit(WindowSpecification windowSpecification)
visit(Array array)
visit(ObjectTable objectTable)
visit(ExceptionExpression obj)
visit(ReturnStatement obj)
visit(JSONObject obj)
visit(XMLExists xmlExists)
visit(XMLCast xmlCast)
visit(IsDistinctCriteria isDistinctCriteria)
~~~

> NOTE: There are 3 kinds of visit methods: Visitor methods for language objects, Visitor methods for symbol objects, Visitor methods for procedure language objects.

### Navigator

![Teiid Query API Navigator]({{ site.baseurl }}/assets/blog/teiid/teiid-query-api-navigator.png)

* The `PreOrPostOrderNavigator` overwrite the public vist methods listed in [LanguageVisitor](#languagevisitor), add define additional 2 public static `doVist` method.
* The `DeepPreOrderNavigator` and `DeepPostOrderNavigator` used for deep navigation, the `PreOrderNavigator` and `PostOrderNavigator` for no deep navigation, each of them also supply a public static `doVist` method.

### Visitor

![Teiid Query API Visitor]({{ site.baseurl }}/assets/blog/teiid/teiid-query-api-visitor.png)

* `ExpressionMappingVisitor` - It is important to use a Post Navigator with this class, otherwise a replacement containing itself will not work
* `AbstractSymbolMappingVisitor` - It is used to update LanguageObjects by replacing one set of symbols with another.  There is one abstract method which must be overridden to define how the mapping lookup occurs.
* `StaticSymbolMappingVisitor` - It is used to update LanguageObjects by replacing the virtual elements/groups present in them with their physical counterparts. It is currently used only to visit Insert/Delete/Update objects and parts of those objects.
* `CommandCollectorVisitor` - This visitor class will traverse a language object tree and collect all sub-commands it finds. It uses a List to collect the sub-commands in the order they're found. The easiest way to use this visitor is to call the static methods which create the visitor, run the visitor, and get the collection. The public visit() methods should NOT be called directly.
* `CorrelatedReferenceCollectorVisitor` - This visitor class will traverse a language object tree and collect references that correspond to correlated subquery references. The easiest way to use this visitor is to call the static method which creates the visitor by passing it the Language Object and the variable context to be looked up. The public visit() methods should NOT be called directly.
* `ElementCollectorVisitor` - This visitor class will traverse a language object tree and collect all element symbol references it finds.  It uses a collection to collect the elements in so different collections will give you different collection properties - for instance, using a Set will remove duplicates. The easiest way to use this visitor is to call the static methods which create the visitor (and possibly the collection), run the visitor, and return the collection. The public visit() methods should NOT be called directly.
* `EvaluatableVisitor` - This visitor class will traverse a language object tree, and determine if the current expression can be evaluated.
* `FunctionCollectorVisitor` - This visitor class will traverse a language object tree and collect all Function references it finds.  It uses a collection to collect the Functions in so different collections will give you different collection properties - for instance, using a Set will remove duplicates. This visitor can optionally collect functions of only a specific name. The easiest way to use this visitor is to call the static methods which create the visitor (and possibly the collection), run the visitor, and return the collection. The public visit() methods should NOT be called directly.
* `GroupCollectorVisitor` - This visitor class will traverse a language object tree and collect all group symbol references it finds.  It uses a collection to collect the groups in so different collections will give you different collection properties - for instance, using a Set will remove duplicates. The easiest way to use this visitor is to call the static methods which create the visitor (and possibly the collection), run the visitor, and get the collection. The public visit() methods should NOT be called directly.
* `PredicateCollectorVisitor` - Walk a tree of language objects and collect any predicate criteria that are found. A predicate criteria is of the following types: CompareCriteria, MatchCriteria, SetCriteria, SubquerySetCriteria, IsNullCriteria
* `ReferenceCollectorVisitor` - his visitor class will traverse a language object tree and collect all references it finds. The easiest way to use this visitor is to call the static methods which create the visitor (and possibly the collection), run the visitor, and return the collection. The public visit() methods should NOT be called directly.
* `SQLStringVisitor` - The SQLStringVisitor will visit a set of language objects and return the corresponding SQL string representation.
* `ValueIteratorProviderCollectorVisitor` - This visitor class will traverse a language object tree and collect all language objects that implement `SubqueryContainer`. By default it uses a java.util.ArrayList to collect the objects in the order they're found. The easiest way to use this visitor is to call one of the static methods which create the visitor, run the visitor, and get the collection. The public visit() methods should NOT be called directly.

#### Examples

##### Example - AggregateSymbolCollectorVisitor find AggregateSymbols and ElementSymbols

~~~
String sql = "SELECT COUNT(e1), MAX(DISTINCT e1) FROM pm1.g1 GROUP BY e1 HAVING MAX(e2) > 0 AND NOT MIN(e2) < 100";
Command command = QueryParser.getQueryParser().parseCommand(sql);

List<Expression> aggs = new ArrayList<Expression>();
List<Expression> elements = new ArrayList<Expression>();
AggregateSymbolCollectorVisitor.getAggregates(command, aggs, elements, null, null, null);

System.out.println(aggs);
System.out.println(elements);
~~~

run above code will output

~~~
[COUNT(e1), MAX(DISTINCT e1), MAX(e2), MIN(e2)]
[e1]
~~~

##### Example - GroupCollectorVisitor find groups

~~~
GroupSymbol group = new GroupSymbol("A", "Accounts.PRODUCT");
ElementSymbol id = new ElementSymbol("ID", group, String.class);
ElementSymbol symbol = new ElementSymbol("SYMBOL", group, String.class);
ElementSymbol name = new ElementSymbol("COMPANY_NAME", group, String.class);

List<ElementSymbol> symbols = Arrays.asList(id, symbol, name);
Select select = new Select(symbols);

From from = new From();
UnaryFromClause clause = new UnaryFromClause();
clause.setGroup(group);
from.addClause(clause);

Query command = new Query();
command.setSelect(select);
command.setFrom(from);

System.out.println(GroupCollectorVisitor.getGroups(command, true));
~~~

run above code will output

~~~
[Accounts.PRODUCT AS A]
~~~

##### Example - ExpressionMappingVisitor repleace Expression

~~~
ElementSymbol a = new ElementSymbol("a"); 
ElementSymbol b = new ElementSymbol("b"); 
ElementSymbol c = new ElementSymbol("c");
Function addition = new Function("+", new Expression[] {a, b });
Function multiplication = new Function("*", new Expression[] {a, b });
Function original = new Function("+", new Expression[] {addition, c });
Map<Expression, Expression> map = new HashMap<Expression, Expression>();
map.put(c, multiplication);
System.out.print(original + " = ");
ExpressionMappingVisitor.mapExpressions(original, map);
System.out.println(original);
~~~

run above code will output

~~~
((a + b) + c) = ((a + b) + (a * b))
~~~
