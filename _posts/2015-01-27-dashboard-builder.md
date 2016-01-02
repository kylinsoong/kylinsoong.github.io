---
layout: blog
title:  "JBoss Dashbuilder"
date:   2015-01-27 18:40:12
categories: jboss
permalink: /dashboard-builder
author: Kylin Soong
duoshuoid: ksoong20150127
---

* Table of contents
{:toc}

## Objectives

This article is a supplement of Dashbuilder's document on [dashbuilder.org](http://www.dashbuilder.org/) and [github.com/kylinsoong/dashboard-builder](https://github.com/kylinsoong/dashboard-builder), primary purpose including:

* Build [Dashbuilder](https://github.com/kylinsoong/dashboard-builder) from source code
* Debug source code under [dashboard-builder](https://github.com/droolsjbpm/dashboard-builder/tree/master/modules).
* Trial Dashbuilder on WildFly

## Deploy dashboard-builder to WildFly

### Build from source code

~~~
$ git clone git@github.com:kylinsoong/dashboard-builder.git
$ cd dashboard-builder/
$ mvn clean install -P h2,jetty -DskipTests
$ cd builder/
$ mvn clean install
~~~

Execute above commands will generate `dashbuilder-VERSION-wildflyX.war` under 'dashboard-builder/builder/target' folder, this war need deploy to a running WildFly Server.

### Create User

Navigate to WildFly Home, execute the following commands to create two user:

~~~
$ ./bin/add-user.sh -a -u root -p password1! -g admin
$ ./bin/add-user.sh -a -u user -p password1! -g user
~~~

### Run the Dashboard Builder

Once WildFly id running, `dashbuilder-VERSION-wildflyX.war` deployed success, login Dashboard Builder via

    http://localhost:8080/dashbuilder

and use the recently created user `root/password1!` as below figure:

![Dashboard Builder Login]({{ site.baseurl }}/assets/blog/dashbuilder-login.png)

## Security configuration in web.xml

~~~
  <security-role>
    <description>Administrator</description>
    <role-name>admin</role-name>
  </security-role>

  <security-role>
    <description>End user</description>
    <role-name>user</role-name>
  </security-role>

  <security-constraint>
    <web-resource-collection>
      <web-resource-name>Free access</web-resource-name>
      <url-pattern>/images/jb_logo.png</url-pattern>
    </web-resource-collection>
  </security-constraint>

  <security-constraint>
    <web-resource-collection>
      <web-resource-name>Restricted access</web-resource-name>
      <url-pattern>/*</url-pattern>
    </web-resource-collection>
    <auth-constraint>
      <role-name>admin</role-name>
      <role-name>user</role-name>
    </auth-constraint>
  </security-constraint>

  <login-config>
    <auth-method>FORM</auth-method>
    <form-login-config>
      <form-login-page>/login.jsp</form-login-page>
      <form-error-page>/login_failed.jsp</form-error-page>
    </form-login-config>
  </login-config>

  <error-page>
    <error-code>403</error-code>
    <location>/not_authorized.jsp</location>
  </error-page>
~~~

* **security-role** - lists all the security roles used in the application, these roles should be mapped with roles exist in Application Server, in WildFly, map roles to a specific appication via `security-domain` which defined in `jboss-web.xml` file.

* **security-constraint** - define the access privileges to a collection of resources using their URL mapping. **web-resource-collection** specifies a list of URL patterns, **auth-constraint** specifies whether authentication is to be used and names the roles authorized to perform the constrained requests.

* **login-config** - define authentication method, in above configuration, Form-based authentication be defined, refer to below `Form-Based Authentication` for more details.

### Form-Based Authentication

Compare with Basic Authentication pop up a raw login form, Form-Based Authentication allows the developer to control the look and feel of the login authentication screens by customizing the login screen and error pages that an HTTP browser presents to the end user. As below figure:

![Form Based Login]({{ site.baseurl }}/assets/blog/jee-web-form-login.png)

When form-based authentication is declared, the following actions occur:

* A client requests access to a protected resource.
* If the client is unauthenticated, the server redirects the client to a login page.
* The client submits the login form to the server.
* The server attempts to authenticate the user. If authentication succeeds, redirect to requested protected resource, If authentication fails, redirected to an error page.

An example of login form:

~~~
<form method="POST" action="j_security_check">
    <input type="text" name="j_username">
    <input type="password" name="j_password">
</form>
~~~

Note that, the action of the login form must always be `j_security_check`, the input name must be `j_username` and the input password must be `j_password`.

## Use Mysql with dashboard-builder

* [Step by step procedure](https://github.com/droolsjbpm/dashboard-builder/blob/master/builder/src/main/wildfly8/README.md)
* [Set up Datasource](https://github.com/jbosschina/wildfly-dev-cookbook/blob/master/persistence/create-ds-mysql.cli)

## ControllerServlet

ControllerServlet is the entry point for UI request, all request(/workspace/*, /jsp/*, /kpi/*) will go to ControllerServlet, below figure is the sequence diagram of dashboard-builder login:

![Login Process]({{ site.baseurl }}/assets/blog/dashbuilder.war-servlet.png)

### web fragment

Started from Servlet 3.0, `web-fragment.xml` be introduced for pluggability of library jars which are packaged under WEB-INF/lib, The content of `web-fragment.xml` are almost same as `web.xml`, the `web-fragment.xml` be placed under classpath's META-INF folder.

For example, in dashbuilder.war's index.jsp define a jsp forward to Servlet

~~~
<jsp:forward page="workspace"/>
~~~

`workspace` define in WEB-INF/lib/dashboard-ui-core-6.4.0-SNAPSHOT.jar/META-INF/web-fragment.xml, rather than wewb.xml, the `workspace` definition looks:

~~~
<servlet>
    <servlet-name>Controller</servlet-name>
    <servlet-class>org.jboss.dashboard.ui.controller.ControllerServlet</servlet-class>
    <load-on-startup>5</load-on-startup>
</servlet>
<servlet-mapping>
    <servlet-name>Controller</servlet-name>
    <url-pattern>/workspace/*</url-pattern>
</servlet-mapping>
~~~

### ControllerServlet init

The following will dive into ControllerServlet init.

**init App Directories** 

The following 3 directory path be formed and set to @ApplicationScoped scope entiry `org.jboss.dashboard.Application`:

* **baseAppDir** -> standalone/deployments/dashbuilder.war
* **baseConfigDir** -> standalone/deployments/dashbuilder.war/WEB-INF/etc
* **baseLibDir** -> standalone/deployments/dashbuilder.war/WEB-INF/lib

Key code used to extract baseAppDir:

~~~
baseAppDir = new File(getServletContext().getRealPath("/")).getPath();
~~~

**Startable Start**

The Startable happens in ControllerServlet init, the sequence like

![Startable Start]({{ site.baseurl }}/assets/blog/jboss-dashbuilder-controllerServlet-init.png)

All 10 Startable be started including:

~~~
org.jboss.dashboard.security.UIPolicy
org.jboss.dashboard.workspace.PanelsProvidersManagerImpl
org.jboss.dashboard.workspace.SkinsManagerImpl
org.jboss.dashboard.initialModule.InitialModulesManager
org.jboss.dashboard.cluster.ClusterNodesManager
org.jboss.dashboard.workspace.LayoutsManagerImpl
org.jboss.dashboard.ui.resources.ResourceManagerImpl
org.jboss.dashboard.workspace.EnvelopesManagerImpl
org.jboss.dashboard.DeploymentScanner
org.jboss.dashboard.database.hibernate.HibernateInitializer
~~~

**Hibernate cfg**


### HibernateInitializer

Startable HibernateInitializer start initializes the Hibernate framework. It reads all the *.hbm.xml files and push them as part of the Hibernate configuration. Furthermore, initializes a SessionFactory object that will be used further by transactions. 

dashbuilder.war's total 16 .hbm.xml files be placed in 7 places:

**1. dashbuilder.war/WEB-INFO/etc**

~~~
hibernate.cfg.xml
~~~

**2. dashbuilder.war/WEB-INF/lib/dashboard-security-VERSION.jar**

~~~
org/jboss/dashboard/security/PermissionDescriptor.hbm.xml
~~~

**3. dashbuilder.war/WEB-INF/lib/dashboard-commons-VERSION.jar**

~~~
org/jboss/dashboard/cluster/ClusterNode.hbm.xml
org/jboss/dashboard/database/InstalledModule.hbm.xml
org/jboss/dashboard/database/DataSourceEntry.hbm.xml
~~~

**4. dashbuilder.war/WEB-INF/lib/dashboard-provider-core-VERSION.jar**

~~~
org/jboss/dashboard/provider/DataProvider.hbm.xml
~~~

**5. dashbuilder.war/WEB-INF/lib/dashboard-ui-core-VERSION.jar**

~~~
org/jboss/dashboard/ui/resources/GraphicElement.hbm.xml
org/jboss/dashboard/workspace/Section.hbm.xml
org/jboss/dashboard/workspace/PanelInstance.hbm.xml
org/jboss/dashboard/workspace/PanelParameter.hbm.xml
org/jboss/dashboard/workspace/Panel.hbm.xml
org/jboss/dashboard/workspace/Workspace.hbm.xml
~~~

**6. dashbuilder.war/WEB-INF/lib/dashboard-displayer-core-VERSION.jar**

~~~
org/jboss/dashboard/kpi/KPI.hbm.xml
~~~

**7. dashbuilder.war/WEB-INF/lib/dashboard-ui-panels-VERSION.jar**

~~~
org/jboss/dashboard/ui/panel/advancedHTML/HtmlCode.hbm.xml
org/jboss/dashboard/ui/panel/dataSourceManagement/DataSourceColumnEntry.hbm.xml
org/jboss/dashboard/ui/panel/dataSourceManagement/DataSourceTableEntry.hbm.xml
~~~

The key Hibernate API used in dashbuilder to init the SessionFactory looks

~~~
Configuration hbmConfig = new Configuration().configure(new File(hibernate.cfg.xml));
loadHibernateDescriptors(hbmConfig);
ServiceRegistryBuilder serviceRegistryBuilder = new ServiceRegistryBuilder().applySettings(hbmConfig.getProperties());
ServiceRegistry serviceRegistry = serviceRegistryBuilder.buildServiceRegistry();
SessionFactory factory = hbmConfig.buildSessionFactory(serviceRegistry);
~~~

Completed runable code refer to [HibernateInitializerTest](https://raw.githubusercontent.com/kylinsoong/teiid-test/master/dashboard/src/main/java/org/jboss/teiid/dashboard/hibernate/HibernateInitializerTest.java)

