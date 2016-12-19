---
layout: blog
title:  "jBPM core engine api example"
date:   2016-12-19 18:00:12
categories: jbpm
permalink: /jbpm-core-api
author: Kylin Soong
duoshuoid: ksoong2016121902
excerpt: org.kie.api.KieBase, org.kie.api.runtime.KieSession
---

* Table of contents
{:toc}

## KieBase

![KieBase]({{ site.baseurl }}/assets/blog/jbpm/KieBase.png)

~~~
KieHelper kieHelper = new KieHelper();
KieBase kieBase = kieHelper
                 .addResource(ResourceFactory.newClassPathResource("sayHello.bpmn2"))
                 .build();
~~~

## KieSession

![KieSession]({{ site.baseurl }}/assets/blog/jbpm/KieSession.png)

~~~
KieSession ksession = kieBase.newKieSession();
ProcessInstance processInstance = ksession.startProcess("sayhello.sayHello");
~~~

### Event Listeners

![ProcessEventListener]({{ site.baseurl }}/assets/blog/jbpm/ProcessEventListener.png)

~~~
eSession ksession = kieBase.newKieSession();
KieRuntimeLogger logger = KieServices.Factory.get().getLoggers().newConsoleLogger(ksession);
ksession.startProcess("sayhello.sayHello");
logger.close();
~~~

### Correlation Keys

![CorrelationAwareProcessRuntime]({{ site.baseurl }}/assets/blog/jbpm/CorrelationAwareProcessRuntime.png)

## RuntimeManager

![RuntimeManager]({{ site.baseurl }}/assets/blog/jbpm/RuntimeManager.png)

~~~
RuntimeEnvironment environment = RuntimeEnvironmentBuilder.Factory.get()
        .newDefaultInMemoryBuilder()
        .addAsset(ResourceFactory.newClassPathResource("rewards.bpmn"), ResourceType.BPMN2)
        .get();

RuntimeManager manager = RuntimeManagerFactory.Factory.get().newSingletonRuntimeManager(environment);

RuntimeEngine runtime = manager.getRuntimeEngine(EmptyContext.get());

KieSession ksession = runtime.getKieSession();

manager.disposeRuntimeEngine(runtime);
~~~

### Configuration

![RuntimeEnvironment]({{ site.baseurl }}/assets/blog/jbpm/RuntimeEnvironment.png)

## Services




