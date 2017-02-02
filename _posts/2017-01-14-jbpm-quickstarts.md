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

## Script task

### HelloWorld

HelloWorld 流程如下图所示

![HelloWorld]({{ site.baseurl }}/assets/blog/jbpm/jbpm-quickstarts-helloworld.png)

如上为一简单的流程，仅有一个Script Task节点，流程运行Script Task节点执行Java代码，输出

~~~
Hello World jBPM
~~~

* [HelloWorld.java](https://raw.githubusercontent.com/kylinsoong/jbpm-examples/master/quickstarts/src/main/java/org/jbpm/quickstarts/helloworld/HelloWorld.java)
* [HelloWorld.bpmn2](https://raw.githubusercontent.com/kylinsoong/jbpm-examples/master/quickstarts/src/main/resources/quickstarts/helloworld/HelloWorld.bpmn2)

**示例运行**

~~~
KieHelper kieHelper = new KieHelper();
KieBase kieBase = kieHelper.addResource(ResourceFactory.newClassPathResource("quickstarts/helloworld/HelloWorld.bpmn2")).build();
KieSession ksession = kieBase.newKieSession();
ksession.startProcess("org.jbpm.quickstarts.HelloWorld");
~~~

### Looping

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

**示例运行**

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

## Service task

Service task 代表执行 jBPM 引擎之外的一个抽象工作，常见的 Service task 有：

* 接发邮件
* 日志记录
* 调运 Web Service

### 

## Business rule task

### HelloWorld

HelloWorld Business rule task 流程如下：

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

**示例运行**

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

User Task 是指节点必须有人的参与后才能够完成，是 BPM 重要特新的体现，User Task 必须使用数据库存储流程运行时数据.

### Evaluation

如下为本部分使用到的流程：

![User Task]({{ site.baseurl }}/assets/blog/jbpm/jbpm-quickstarts-usertask.png)

如上图，流程执行如下

1. Self Evaluation
2. PM Evaluation
3. HR Evaluation

相关代码：

* [Evaluation.java](https://raw.githubusercontent.com/kylinsoong/jbpm-examples/master/quickstarts/src/main/java/org/jbpm/quickstarts/humantask/Evaluation.java)
* [Evaluation.bpmn2](https://raw.githubusercontent.com/kylinsoong/jbpm-examples/master/quickstarts/src/main/resources/quickstarts/humantask/Evaluation.bpmn2)

**示例运行**

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

## Reusable sub-process

### Pass parameters between Parent process and Reusable Sub-Process

Reusable Sub-Process是在主流程里面执行另为一个流程（子流程），当流程执行到Reusable Sub-Process节点时流程执行引擎根据提供的流程（子流程）ID，Reusable Sub-Process示例流程如下（主流程和子流程）：

![Reusable Sub-Process Parent]({{ site.baseurl }}/assets/blog/jbpm/reusable-subprocess-parent.png)

![Reusable Sub-Process Child]({{ site.baseurl }}/assets/blog/jbpm/reusable-subprocess-child.png)

Reusable Sub-Process示例流程运行时传入三条字符串message 1，message 2和message 3，在流程运行时主流程的Format tag节点中生成一个tag，在子流程Apply Tag中将生成的tsg添加到每一条消息的末尾，流程运行结束输出三条消息确认设定tag情况。主流程的Format tag节点为Service Task节点，运行时执行的Java代码如下：

~~~
System.out.println("Parent-process id = "+kcontext.getProcessInstance().getId());  
java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("mm-dd-yyyy");  
kcontext.setVariable("tag",  sdf.format(new java.util.Date()));
~~~

子流程Apply Tag节点为Service Task节点，运行时执行的Java代码如下：

~~~
System.out.println("Child-process id = "+kcontext.getProcessInstance().getId());  
java.util.List<String> taggedMessages = new java.util.ArrayList<String>();  
for (Object message : internalMessages){  
    taggedMessages.add(((String)message)+" - "+internalTag);      
}  
kcontext.setVariable("internalMessages",taggedMessages); 
~~~

* [ReusableSubProcess.java](https://raw.githubusercontent.com/kylinsoong/jbpm-examples/master/quickstarts/src/main/java/org/jbpm/quickstarts/reusable/ReusableSubProcess.java)
* [reusableSubProcess-Parent.bpmn2](https://raw.githubusercontent.com/kylinsoong/jbpm-examples/master/quickstarts/src/main/resources/quickstarts/reusable/reusableSubProcess-Parent.bpmn2)
* [reusableSubProcess-Child.bpmn2](https://raw.githubusercontent.com/kylinsoong/jbpm-examples/master/quickstarts/src/main/resources/quickstarts/reusable/reusableSubProcess-Child.bpmn2)

**示例运行**

~~~
KieHelper kieHelper = new KieHelper();
KieBase kieBase = kieHelper
        .addResource(ResourceFactory.newClassPathResource("quickstarts/reusable/reusableSubProcess-Parent.bpmn2"))
        .addResource(ResourceFactory.newClassPathResource("quickstarts/reusable/reusableSubProcess-Child.bpmn2"))
        .build();
KieSession ksession = kieBase.newKieSession();
        
List<String> messages = new ArrayList<String>();
messages.add("message 1");
messages.add("message 2");
messages.add("message 3");
Map<String,Object> params = new HashMap<String, Object>();
params.put("messages", messages); 
        
System.out.println("Before: " + params.get("messages"));
ProcessInstance process = ksession.startProcess("org.jbpm.quickstarts.reusableSubProcess.Parent", params
WorkflowProcessInstance processInstance = (WorkflowProcessInstance) process;
System.out.println("After: " + processInstance.getVariable("messages"));
ksession.dispose();
~~~

示例流程运行输出结果如下：

~~~
Before: [message 1, message 2, message 3]
Parent-process id = 1
Child-process id = 2
After: [message 1 - 11-02-2017, message 2 - 11-02-2017, message 3 - 11-02-2017]
~~~

## Embedded sub-process

### Set tag via Embedded sub-process

EmbeddedSubProcess 是指在流程设计时子流程镶嵌在主流程，如下为 EmbeddedSubProcess 流程示意：

![Embedded Sub-Process]({{ site.baseurl }}/assets/blog/jbpm/embedded-subprocess.png)

如图 `Tagger Embedded Process` 为镶嵌在主流程中的子流程，EmbeddedSubProcess流程运行时传输三条字符串message 1，message 2和message 3，在流程运行时主流程的Format tag节点中生成一个tag，在子流程Apply Tag中将生成的tsg添加到每一条消息的末尾，流程运行结束输出三条消息确认设定tag情况。

主流程的Format tag节点为Service Task节点，运行时执行的Java代码如下：

~~~
System.out.println("Parent-process id = "+kcontext.getProcessInstance().getId());
java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("mm-dd-yyyy");
kcontext.setVariable("tag",  sdf.format(new java.util.Date()));
~~~

即将当前的时间以mm-dd-yyyy格式作为tag。子流程Apply Tag节点为Service Task节点，运行时执行的Java代码如下：

~~~
System.out.println("Embedded-process id = "+kcontext.getProcessInstance().getId());
java.util.List<String> taggedMessages = new java.util.ArrayList<String>();
for (Object message : messages){
    taggedMessages.add(((String)message)+" - "+tag);    
}
kcontext.setVariable("messages",taggedMessages);
~~~

* [EmbeddedSubProcess.java](https://raw.githubusercontent.com/kylinsoong/jbpm-examples/master/quickstarts/src/main/java/org/jbpm/quickstarts/embedded/EmbeddedSubProcess.java)
* [embeddedSubProcess.bpmn2](https://raw.githubusercontent.com/kylinsoong/jbpm-examples/master/quickstarts/src/main/resources/quickstarts/embedded/embeddedSubProcess.bpmn2)

**示例运行**

~~~
KieHelper kieHelper = new KieHelper();
KieBase kieBase = kieHelper
        .addResource(ResourceFactory.newClassPathResource("quickstarts/embedded/embeddedSubProcess.bpmn2"))
        .build();
KieSession ksession = kieBase.newKieSession();
        
List<String> messages = new ArrayList<String>();
messages.add("message 1");
messages.add("message 2");
messages.add("message 3");
Map<String,Object> params = new HashMap<String, Object>();
params.put("messages", messages); 
        
System.out.println("Before: " + params.get("messages"));
ProcessInstance process = ksession.startProcess("org.jbpm.quickstarts.embeddedSubProcess", params);
WorkflowProcessInstance processInstance = (WorkflowProcessInstance) process;
System.out.println("After: " + processInstance.getVariable("messages"));
ksession.dispose();
~~~

流程运行输出的结果如下：

~~~
Before: [message 1, message 2, message 3]
Parent-process id = 1
Embedded-process id = 1
After: [message 1 - 32-02-2017, message 2 - 32-02-2017, message 3 - 32-02-2017]
~~~

## Multi-instance sub-process

###
