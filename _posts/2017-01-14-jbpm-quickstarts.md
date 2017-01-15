---
layout: blog
title:  "jBPM 示例"
date:   2017-01-14 22:00:12
categories: jbpm
permalink: /jbpm-quickstarts
author: Kylin Soong
duoshuoid: ksoong2017011404
excerpt: A series of quickstart example for jBPM
---

* Table of contents
{:toc}

## HelloWorld

HelloWorld 流程如下图所示：


如上为一简单的流程，仅有一个Script Task节点，流程运行Script Task节点执行Java代码，输出

![HelloWorld]({{ site.baseurl }}/assets/blog/jbpm/jbpm-quickstarts-helloworld.png)

~~~
Hello World jBPM
~~~

* [HelloWorld.java](https://raw.githubusercontent.com/kylinsoong/jbpm-examples/master/quickstarts/src/main/java/org/jbpm/quickstarts/helloworld/HelloWorld.java)
* [HelloWorld.bpmn2](https://raw.githubusercontent.com/kylinsoong/jbpm-examples/master/quickstarts/src/main/resources/quickstarts/helloworld/HelloWorld.bpmn2)

### 示例运行

~~~
KieHelper kieHelper = new KieHelper();
KieBase kieBase = kieHelper.addResource(ResourceFactory.newClassPathResource("quickstarts/helloworld/HelloWorld.bpmn2")).build();
KieSession ksession = kieBase.newKieSession();
ksession.startProcess("org.jbpm.quickstarts.HelloWorld");
~~~

## Looping

Looping流程如下图所示：

![Looping]({{ site.baseurl }}/assets/blog/jbpm/jbpm-quickstarts-looping.png)

如上图，Looping流程有三个Script Task节点，Init, Loop, Done。

Init节点是Loop开始节点，它初始化两个变量count和i，分别赋值5和0，如下

~~~
System.out.println("Loop started");  
kcontext.setVariable("count", 5);  
kcontext.setVariable("i", 0);
~~~

Loop节点每次输出变量i的值，并给变量i加1,当变量i小于count的值5时，执行循环，如下

~~~
System.out.println("  i = " + i);  
kcontext.setVariable("i", i+1);
~~~

Done节点输出Looping流程结束字符串，如下

~~~
System.out.println("Loop completed");
~~~

* [Looping.java](https://raw.githubusercontent.com/kylinsoong/jbpm-examples/master/quickstarts/src/main/java/org/jbpm/quickstarts/looping/Looping.java)
* [Looping.bpmn2](https://raw.githubusercontent.com/kylinsoong/jbpm-examples/master/quickstarts/src/main/resources/quickstarts/looping/Looping.bpmn2)

### 示例运行

~~~
KieHelper kieHelper = new KieHelper();
KieBase kieBase = kieHelper.addResource(ResourceFactory.newClassPathResource("quickstarts/looping/looping.bpmn2")).build();
KieSession ksession = kieBase.newKieSession();
ksession.startProcess("org.jbpm.quickstarts.looping");
~~~

运行Looping流程输出结果如下：

~~~
Loop started
  i = 0
  i = 1
  i = 2
  i = 3
  i = 4
Loop completed
~~~

## Business rule task

Business rule task 流程如下：

![Business rule]({{ site.baseurl }}/assets/blog/jbpm/jbpm-quickstarts-businessrules.png)

如上图流程只有一个节点, 该节点为 Business Rule Task, 它关联的 ruleflow-group 为 `output`, 流程运行到该节点时执行所有 `output` Business Rule。Business Rule 内容输出字符串，内容如下

~~~
package org.jbpm.quickstarts

rule "Hello World Rule 1" ruleflow-group "output"
when
	eval( true )
then
	System.out.println("Hello World Rule 1");
end
~~~

* [RuleTask.java](https://raw.githubusercontent.com/kylinsoong/jbpm-examples/master/quickstarts/src/main/java/org/jbpm/quickstarts/rule/RuleTask.java)
* [ruletaskprocess.bpmn2](https://raw.githubusercontent.com/kylinsoong/jbpm-examples/master/quickstarts/src/main/resources/quickstarts/rule/ruletaskprocess.bpmn2)
* [ruletaskprocess-rule.drl](https://raw.githubusercontent.com/kylinsoong/jbpm-examples/master/quickstarts/src/main/resources/quickstarts/rule/ruletaskprocess-rule.drl)
* [ruletaskprocess-rule2.drl](https://raw.githubusercontent.com/kylinsoong/jbpm-examples/master/quickstarts/src/main/resources/quickstarts/rule/ruletaskprocess-rule2.drl)

### 示例运行

~~~
KieHelper kieHelper = new KieHelper();
KieBase kieBase = kieHelper
        .addResource(ResourceFactory.newClassPathResource("quickstarts/rule/ruletaskprocess.bpmn2"))
        .addResource(ResourceFactory.newClassPathResource("quickstarts/rule/ruletaskprocess-rule.drl"))
        .addResource(ResourceFactory.newClassPathResource("quickstarts/rule/ruletaskprocess-rule2.drl"))
        .build();
KieSession ksession = kieBase.newKieSession();
ksession.startProcess("org.jbpm.quickstarts.ruletaskprocess");
ksession.dispose();
~~~

RuleTask流程运行输出结果：

~~~
Hello World Rule 1
Hello World Rule 2
~~~

## User Task

User Task 是指节点必须有人的参与后才能够完成，是 BPM 重要特新的体现，User Task 必须使用数据库存储流程运行时数据，如下为本部分使用到的流程示意：

![User Task]({{ site.baseurl }}/assets/blog/jbpm/jbpm-quickstarts-usertask.png)

如上图，流程执行如下

1. Self Evaluation
2. PM Evaluation
3. HR Evaluation

相关代码：

* [Evaluation.java](https://raw.githubusercontent.com/kylinsoong/jbpm-examples/master/quickstarts/src/main/java/org/jbpm/quickstarts/humantask/Evaluation.java)
* [Evaluation.bpmn2](https://raw.githubusercontent.com/kylinsoong/jbpm-examples/master/quickstarts/src/main/resources/quickstarts/humantask/Evaluation.npmn2)

### 示例运行

~~~
// Prepare datasource
JBPMHelper.startH2Server();
JBPMHelper.setupDataSource();
        
// Setup KieSession and TaskService
RuntimeEnvironment environment = RuntimeEnvironmentBuilder.Factory.get().newDefaultBuilder()
        .userGroupCallback(new UserGroupCallback(){

            @Override
            public boolean existsUser(String userId) {                       
                return true;
            }

            @Override
            public boolean existsGroup(String groupId) {
               return true;
            }

            @Override
            public List<String> getGroupsForUser(String userId, List<String> groupIds, List<String> allExistingGroupIds) {
                List<String> result = new ArrayList<>();
                if(userId.equals("john")){
                    result.add("PM");
                } else if(userId.equals("mary")) {
                    result.add("HR");
                }
                return result;
            }})
        .addAsset(KieServices.Factory.get().getResources().newClassPathResource("quickstarts/humantask/Evaluation.bpmn2"), ResourceType.BPMN2)
        .get();

RuntimeManager manager = RuntimeManagerFactory.Factory.get().newSingletonRuntimeManager(environment);
RuntimeEngine engine = manager.getRuntimeEngine(null);
KieSession ksession = engine.getKieSession();
TaskService taskService = engine.getTaskService();

// Start a new process instance
Map<String, Object> params = new HashMap<String, Object>();
params.put("employee", "kylin");
params.put("reason", "Yearly performance evaluation");
ksession.startProcess("org.jbpm.quickstarts.Evaluation", params);
System.out.println("Process started ...");

// Complete Self Evaluation
List<TaskSummary> tasks = taskService.getTasksAssignedAsPotentialOwner("kylin", "en-UK");
TaskSummary task = tasks.get(0);
System.out.println("'kylin' completing task " + task.getName() + ": " + task.getDescription());
taskService.start(task.getId(), "kylin");
Map<String, Object> results = new HashMap<String, Object>();
results.put("performance", "exceeding");
taskService.complete(task.getId(), "kylin", results);

// Complete PM Evaluation
tasks = taskService.getTasksAssignedAsPotentialOwner("john", "en-UK");
task = tasks.get(0);
System.out.println(" 'john' completing task " + task.getName() + ": " + task.getDescription());
taskService.claim(task.getId(), "john");
taskService.start(task.getId(), "john");
results = new HashMap<String, Object>();
results.put("performance", "acceptable");
taskService.complete(task.getId(), "john", results);

// Complete HR Evaluation
tasks = taskService.getTasksAssignedAsPotentialOwner("mary", "en-UK");
task = tasks.get(0);
System.out.println(" 'mary' completing task " + task.getName() + ": " + task.getDescription());
taskService.claim(task.getId(), "mary");
taskService.start(task.getId(), "mary");
results = new HashMap<String, Object>();
results.put("performance", "outstanding");
taskService.complete(task.getId(), "mary", results);

System.out.println("Process instance completed");

ksession.dispose();
manager.disposeRuntimeEngine(engine);
manager.close();
~~~

流程执行输出

~~~
Process started ...
'kylin' completing task Self Evaluation: Please perform a self-evalutation.
 'john' completing task PM Evaluation: You need to evaluate kylin.
 'mary' completing task HR Evaluation: You need to evaluate kylin.
Process instance completed
~~~
