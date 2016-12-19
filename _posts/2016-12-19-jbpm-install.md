---
layout: blog
title:  "Install jBPM From jbpm-installer"
date:   2016-12-19 12:00:12
categories: jbpm
permalink: /jbpm-install
author: Kylin Soong
duoshuoid: ksoong2016121901
excerpt: Install jBPM From jbpm-installer
---

* Table of contents
{:toc}

This blog article for quick install jbpm from jbpm-installer binary distribution.

## Download

* Download jbpm-6.5.0.Final-installer-full.zip

~~~
wget https://download.jboss.org/jbpm/release/6.5.0.Final/jbpm-6.5.0.Final-installer-full.zip
~~~

## Installation

With <<Installaton, Installaton>> section's zip file, 6 step are used to install jBPM.

### 1. Get jbpm-installer

~~~
unzip jbpm-6.5.0.Final-installer-full.zip
~~~

> NOTE: A `jbpm-installer` folder will be generated, the following installation steps depend on this folder.

### 2. Install WildFly

~~~
unzip jbpm-installer/lib/jboss-wildfly-10.0.0.Final.zip
~~~

### 3. Install jBPM console

~~~
unzip jbpm-installer/lib/jbpm-console-6.5.0.Final-wildfly-10.0.0.Final.war -d ./wildfly-10.0.0.Final/standalone/deployments/jbpm-console.war
touch ./wildfly-10.0.0.Final/standalone/deployments/jbpm-console.war.dodeploy
~~~

### 4. Install kie Server

~~~
unzip jbpm-installer/lib/kie-server-6.5.0.Final-wildfly-10.0.0.Final.war -d ./wildfly-10.0.0.Final/standalone/deployments/kie-server.war
touch ./wildfly-10.0.0.Final/standalone/deployments/kie-server.war.dodeploy
~~~

### 5. Set up user group

Change into WildFly Home, execute add users shell script [add-users.sh]({{ site.baseurl }}/assets/download/shell/add-users.sh):

~~~
./add-users.sh
~~~ 

Alternatively, execute below commands under WildFly Home

~~~
./bin/add-user.sh -a -u admin -p password1! -g admin,analyst,kiemgmt,rest-all,kie-server
./bin/add-user.sh -a -u krisv -p password1! -g admin,analyst,rest-all,kie-server
./bin/add-user.sh -a -u john -p password1! -g analyst,Accounting,PM
./bin/add-user.sh -a -u mary -p password1! -g analyst,HR
./bin/add-user.sh -a -u sales-rep -p password1! -g analyst,sales
./bin/add-user.sh -a -u jack -p password1! -g analyst,IT
./bin/add-user.sh -a -u katy -p password1! -g analyst,HR
./bin/add-user.sh -a -u salaboy -p password1! -g admin,analyst,IT,HR,Accounting,rest-all
./bin/add-user.sh -a -u kieserver -p password1! -g kie-server
~~~

> NOTE: These users are used for test and use simple plain txt based jaas login module, if use OpenLDAP server, this step is redundant.

### 6. Start jbpm & Validate installation

Change into Wildfly Home, edit `bin/standalone.conf`, make sure WildFly/jBPM server has enough memory

~~~
-Xms2048m -Xmx2048m -XX:MetaspaceSize=256M -XX:MaxMetaspaceSize=512m
~~~

add system properties to disable import example data

~~~
-Dorg.kie.demo=false -Dorg.kie.example=false
~~~

start jBPM via 

~~~
./bin/standalone.sh -b 0.0.0.0 -bmanagement=0.0.0.0 -c standalone-full.xml
~~~

Once start finished, access http://localhost:8080/jbpm-console will log into jBPM console with admin/admin:

![jBPM Welcome]({{ site.baseurl }}/assets/blog/jbpm/jbpm-welcome-page.png)
