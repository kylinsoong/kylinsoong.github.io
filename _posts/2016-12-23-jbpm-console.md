---
layout: blog
title:  "The introduction of jbpm-console"
date:   2016-12-23 18:00:12
categories: jbpm
permalink: /jbpm-console
author: Kylin Soong
duoshuoid: ksoong2016122301
excerpt: The introduction of the jbpm console
---

* Table of contents
{:toc}

## Workbench data and system properties

Accessing http://localhost:8080/jbpm-console will go into the workbench, The workbench stores its data, by default in the directory $WORKING_DIRECTORY/.niogit, for example, `wildfly-10.0.0.Final/.niogit`, but this can overwrite via `-Dorg.uberfire.nio.git.dir`.

### System properties

1. **org.uberfire.nio.git.dir** - Location of the directory .niogit. Default: working directory
2. **org.uberfire.nio.git.daemon.enabled** - Enables/disables git daemon. Default: true
3. **org.uberfire.nio.git.daemon.host** -  If git daemon enabled, uses this property as local host identifier. Default: localhost
4. **org.uberfire.nio.git.daemon.port** -  If git daemon enabled, uses this property as port number. Default: 9418
5. **org.uberfire.nio.git.ssh.enabled** - Enables/disables ssh daemon. Default: true
6. **org.uberfire.nio.git.ssh.host** - If ssh daemon enabled, uses this property as local host identifier. Default: localhost
7. **org.uberfire.nio.git.ssh.port** - If ssh daemon enabled, uses this property as port number. Default: 8001
8. **org.uberfire.nio.git.ssh.cert.dir** -  Location of the directory .security where local certificates will be stored. Default: working directory
9. **org.uberfire.nio.git.hooks** - Location of the directory that contains Git hook scripts that are installed into each repository created (or cloned) in the Workbench. Default: N/A
10. **org.uberfire.nio.git.ssh.passphrase** - Passphrase to access your Operating Systems public keystore when cloning git repositories with scp style URLs; e.g. git@github.com:user/repository.git.
11. **org.uberfire.metadata.index.dir** -  Place where Lucene .index folder will be stored. Default: working directory
12. **org.uberfire.cluster.id** - Name of the helix cluster, for example: kie-cluster
13. **org.uberfire.cluster.zk** - Connection string to zookeeper. This is of the form host1:port1,host2:port2,host3:port3, for example: localhost:2188
14. **org.uberfire.cluster.local.id** - Unique id of the helix cluster node, note that ':' is replaced with '_', for example: node1_12345
15. **org.uberfire.cluster.vfs.lock** - Name of the resource defined on helix cluster, for example: kie-vfs
16. **org.uberfire.cluster.autostart** -  Delays VFS clustering until the application is fully initialized to avoid conflicts when all cluster members create local clones. Default: false
17. **org.uberfire.sys.repo.monitor.disabled** - Disable configuration monitor (do not disable unless you know what you're doing). Default: false
18. **org.uberfire.secure.key** - Secret password used by password encryption. Default: org.uberfire.admin
19. **org.uberfire.secure.alg** - Crypto algorithm used by password encryption. Default: PBEWithMD5AndDES
20. **org.uberfire.domain** - security-domain name used by uberfire. Default: ApplicationRealm
21. **org.guvnor.m2repo.dir** - Place where Maven repository folder will be stored. Default: working-directory/repositories/kie
22. **org.guvnor.project.gav.check.disabled** - Disable GAV checks. Default: false
23. **org.kie.example.repositories** - Folder from where demo repositories will be cloned. The demo repositories need to have been obtained and placed in this folder. Demo repositories can be obtained from the kie-wb-6.2.0-SNAPSHOT-example-repositories.zip artifact. This System Property takes precedence over org.kie.demo and org.kie.example. Default: Not used.
24. **org.kie.demo** - Enables external clone of a demo application from GitHub. This System Property takes precedence over org.kie.example. Default: true
25. **org.kie.example** - Enables example structure composed by Repository, Organization Unit and Project. Default: false
26. **org.kie.build.disable-project-explorer** - Disable automatic build of selected Project in Project Explorer. Default: false

## A quick start of workbench usage

### 1. Login workbench

http://http://localhost:8080/jbpm-console

![jBPM Welcome]({{ site.baseurl }}/assets/blog/jbpm/jbpm-welcome-page.png)

### 2. Create a Organization Unit

`Authoring` -> `Administration` -> `Organizational Units` -> `Manage Organizational Units`

![Organization Unit]({{ site.baseurl }}/assets/blog/jbpm/jbpm-console-organization-unit.png)

Click the blue `Add` button, in the popped up window, enter the Name, Default Group ID, Owner:

![Organization Unit add]({{ site.baseurl }}/assets/blog/jbpm/jbpm-console-organization-unit-add.png)

Click the blue `Ok` button to finish add new Organizational Unit.

### 3. Add a repository

`Authoring` -> `Administration` -> `Repositories` -> `New repository`

![New repository]({{ site.baseurl }}/assets/blog/jbpm/jbpm-console-repository-add.png)

In popped up window, enter a Repository Name and select a appropriate Organization Unit, then click the blue `Finish` button.

![New repository window]({{ site.baseurl }}/assets/blog/jbpm/jbpm-console-repository-add-window.png)

### 4. Create a project

`Authoring` -> `Project Authoring` -> `New Item` -> `Project`

![New project]({{ site.baseurl }}/assets/blog/jbpm/jbpm-console-project-add.png)

In popped up window, enter the Project Name and Artifact ID, click blue `Finish` button

![New project window]({{ site.baseurl }}/assets/blog/jbpm/jbpm-console-project-add-window.png)

### 5. Define a Data Model

`Authoring` -> `Project Authoring` -> `New Item` -> `Data Object`

![New data model]({{ site.baseurl }}/assets/blog/jbpm/jbpm-console-datamodel-add.png)

In popped up window, enter a Data Object, select a package, click the blue `Ok` button

![New data model window]({{ site.baseurl }}/assets/blog/jbpm/jbpm-console-datamodel-add-window.png)

In Data Object Editor, click `add field` button

![New data model field]({{ site.baseurl }}/assets/blog/jbpm/jbpm-console-datamodel-add-field.png)

In popped up window, end a Id and Type, either click blue button `Create and continue`, or `Create`

![New data model field window]({{ site.baseurl }}/assets/blog/jbpm/jbpm-console-datamodel-add-field-window.png)

Below is a Data Model named `Person`, which have 3 fields: id, age, name:

![New data model fields]({{ site.baseurl }}/assets/blog/jbpm/jbpm-console-datamodel-add-fields.png)

### 6. Create a Business rules

`Authoring` -> `Project Authoring` -> `New Item` -> `DRL file`

![New drl]({{ site.baseurl }}/assets/blog/jbpm/jbpm-console-drl-add.png)

In popped up window, enter the DRL file name, select a appropriate package, click the blue `Ok` button

![New drl window]({{ site.baseurl }}/assets/blog/jbpm/jbpm-console-drl-add-window.png)

In the Project Editor view, edit the drl file with some content

![New drl content]({{ site.baseurl }}/assets/blog/jbpm/jbpm-console-drl-content.png)

Click the `Save` button to finish the DRL creation

![New drl create]({{ site.baseurl }}/assets/blog/jbpm/jbpm-console-drl-create.png)

Note that, once click the `Save` button, a window is pop up, add some git commit comment and click blue `Save` button

![New drl create-window]({{ site.baseurl }}/assets/blog/jbpm/jbpm-console-drl-create-window.png)

### 7. Create a Business Process

`Authoring` -> `Project Authoring` -> `New Item` -> `Business Process`

![New bpmn]({{ site.baseurl }}/assets/blog/jbpm/jbpm-console-bpmn.png)

in popped up window, enter the Business Process name, select a appropriate package, click the blue `Ok` button

![New bpmn window]({{ site.baseurl }}/assets/blog/jbpm/jbpm-console-bpmn-window.png)

A BPMN Designer will pop up

![New bpmn designer]({{ site.baseurl }}/assets/blog/jbpm/jbpm-console-bpmn-designer.png)

Click or drag to create a one step HelloWorld Script Task Process

![New bpmn designer create]({{ site.baseurl }}/assets/blog/jbpm/jbpm-console-bpmn-designer-create.png)

Edit Script Task to output 'Hello World BPM' to console

![New bpmn designer task]({{ site.baseurl }}/assets/blog/jbpm/jbpm-console-bpmn-designer-task.png)

Click `Ok` button to finish edit Script Task. In Project Editpr, click `Save` button to finish design process.

### 8. Build and Deploy

`Authoring` -> `Project Authoring` -> `Open Project Editor`

![project editor]({{ site.baseurl }}/assets/blog/jbpm/jbpm-console-project-editor.png)

In the right of menu bar, `Build` -> `Build & Deploy`

![project editor deploy]({{ site.baseurl }}/assets/blog/jbpm/jbpm-console-project-editor-deploy.png)

Once Build Success, `Deploy` -> `Process Deployments`, you will see the "helloworld" project deployed success

![project editor deploy success]({{ site.baseurl }}/assets/blog/jbpm/jbpm-console-project-editor-deploy-success.png)

## Clone repository to local Disk

In jbpm console, `Authoring` -> `Administration`, change into the Repository Editor

![Repository Editor]({{ site.baseurl }}/assets/blog/jbpm/jbpm-console-repository-editor.png)

Copy the git url, eg "git://localhost:9418/demo", clone to local disk

~~~
$ git clone git://localhost:9418/demo
$ cd demo/
$ ls hellowold/src/main/resources/org/ksoong/hellowold/
helloworld.bpmn2  helloworld.drl  WorkDefinitions.wid
$ ls hellowold/src/main/java/org/ksoong/hellowold/
Person.java
~~~
