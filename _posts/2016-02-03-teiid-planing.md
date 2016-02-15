---
layout: blog
title:  "Understanding Federated Planning"
date:   2016-02-03 17:00:00
categories: teiid
permalink: /teiid-planning
author: Kylin Soong
duoshuoid: ksoong2015020301
excerpt: Teiid at its core is a federated relational query engine, this article contain examples and supplement of [Teiid Federated Planning Document](https://teiid.gitbooks.io/documents/content/reference/Federated_Planning.html).
---

* Table of contents
{:toc}

## Planning Overview Example

In [Planning Overview Document](https://teiid.gitbooks.io/documents/content/reference/Planning_Overview.html), there is a example for retrieving all engineering employees born since 1970 via

~~~
SELECT e.title, e.lastname FROM Employees AS e JOIN Departments AS d ON e.dept_id = d.dept_id WHERE year(e.birthday) >= 1970 AND d.dept_name = 'Engineering'
~~~

In this section we will look more details of this example.

![The start of logical plan]({{ site.baseurl }}/assets/blog/query_plan_2.png)

The `CANONICAL PLAN` is the start of logical plan, it looks

~~~
Project(groups=[pm1.EMPLOYEES AS e], props={PROJECT_COLS=[e.TITLE, e.LASTNAME]})
  Select(groups=[pm1.DEPARTMENTS AS d], props={SELECT_CRITERIA=d.DEPT_NAME = 'Engineering'})
    Select(groups=[pm1.EMPLOYEES AS e], props={SELECT_CRITERIA=year(e.BIRTHDAY) >= 1970})
      Join(groups=[pm1.EMPLOYEES AS e, pm1.DEPARTMENTS AS d], props={JOIN_TYPE=INNER JOIN, JOIN_STRATEGY=NESTED_LOOP, JOIN_CRITERIA=[e.DEPT_ID = d.DEPT_ID]})
        Source(groups=[pm1.EMPLOYEES AS e])
        Source(groups=[pm1.DEPARTMENTS AS d])
~~~

The logical plan optimization including the following steps:

1. GENERATE CANONICAL PLAN
2. EXECUTING PlaceAccess
3. EXECUTING PushSelectCriteria
4. EXECUTING PushNonJoinCriteria
5. EXECUTING CleanCriteria
6. EXECUTING RaiseAccess
7. EXECUTING CopyCriteria
8. EXECUTING CleanCriteria
9. EXECUTING PlanJoins
10. EXECUTING PushSelectCriteria
11. EXECUTING RaiseAccess
12. EXECUTING RulePlanOuterJoins
13. EXECUTING ChooseJoinStrategy
14. EXECUTING ChooseDependent
15. EXECUTING AssignOutputElements
16. EXECUTING CalculateCost
17. EXECUTING ImplementJoinStrategy
18. EXECUTING MergeCriteria
19. EXECUTING PlanSorts
20. EXECUTING CollapseSource
21. CONVERTING PLAN TREE TO PROCESS TREE
22. OPTIMIZATION COMPLETE:

optimization complete will create a Processor Plan, it looks

~~~
AccessNode(0) output=[e.TITLE, e.LASTNAME] SELECT g_0.TITLE, g_0.LASTNAME FROM pm1.EMPLOYEES AS g_0, pm1.DEPARTMENTS AS g_1 WHERE (g_0.DEPT_ID = g_1.DEPT_ID) AND (year(g_0.BIRTHDAY) >= 1970) AND (g_1.DEPT_NAME = 'Engineering')
~~~ 

[Detailed logical plan optimization log]({{ site.baseurl }}/assets/download/teiid-logicalplan-optimization-process-log)

## Query Planner Example

In [Query Planner Document](https://teiid.gitbooks.io/documents/content/reference/Query_Planner.html), 'Canonical Plan and All Nodes' section, the example query

~~~
SELECT max(pm1.g1.e1) FROM pm1.g1 WHERE e2 = 1
~~~

create a logical plan like

![The start of logical plan 3]({{ site.baseurl }}/assets/blog/teiid-query-plan-3.png)

~~~
Project(groups=[anon_grp0], props={PROJECT_COLS=[anon_grp0.agg0 AS expr1]})
  Group(groups=[anon_grp0], props={SYMBOL_MAP={anon_grp0.agg0=MAX(pm1.G1.E1)}})
    Select(groups=[pm1.G1], props={SELECT_CRITERIA=pm1.G1.E2 = 1})
      Source(groups=[pm1.G1])
~~~

The logical plan optimization including the following steps:

1. GENERATE CANONICAL
2. EXECUTING PlaceAccess
3. EXECUTING PushSelectCriteria
4. EXECUTING CleanCriteria
5. EXECUTING RaiseAccess
6. EXECUTING PushAggregates
7. EXECUTING AssignOutputElements
8. EXECUTING CalculateCost
9. EXECUTING MergeCriteria
10. EXECUTING PlanSorts
11. EXECUTING CollapseSource
12. CONVERTING PLAN TREE TO PROCESS TREE
13. OPTIMIZATION COMPLETE

[Detailed logical plan optimization log]({{ site.baseurl }}/assets/download/teiid-logicalplan-optimization-process-log-2)

### Reading a Debug Plan Example

In [Reading a Debug Plan Document](https://teiid.gitbooks.io/documents/content/reference/Query_Planner.html#_reading_a_debug_plan), the example query

~~~
SELECT e1 FROM (SELECT e1 FROM pm1.g1) AS x
~~~

canonical plan form like

![The start of logical plan 4]({{ site.baseurl }}/assets/blog/teiid-query-plan-4.png)

~~~
Project(groups=[x], props={PROJECT_COLS=[x.E1]})
  Source(groups=[x], props={NESTED_COMMAND=SELECT pm1.G1.E1 FROM pm1.G1, SYMBOL_MAP={x.E1=pm1.G1.E1}})
    Project(groups=[pm1.G1], props={PROJECT_COLS=[pm1.G1.E1]})
      Source(groups=[pm1.G1])
~~~

The logical plan optimization including the following steps:

1. GENERATE CANONICAL
2. EXECUTING PlaceAccess
3. EXECUTING AssignOutputElements
4. EXECUTING MergeVirtual
5. EXECUTING CleanCriteria
6. EXECUTING RaiseAccess
7. EXECUTING AssignOutputElements
8. EXECUTING CalculateCost
9. EXECUTING PlanSorts
10. EXECUTING CollapseSource
11. CONVERTING PLAN TREE TO PROCESS TREE
12. OPTIMIZATION COMPLETE

[Detailed logical plan optimization log]({{ site.baseurl }}/assets/download/teiid-logicalplan-optimization-process-log-3)
