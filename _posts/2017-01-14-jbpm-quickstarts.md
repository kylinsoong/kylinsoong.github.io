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


