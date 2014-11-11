---
layout: blog
title:  "Teiid embedded samples OpenLDAP"
date:   2014-11-11 21:45:00
categories: teiid
permalink: /teiid-ldap
author: Kylin Soong
duoshuoid: ksoong20141111
---

Teiid Embedded is a light-weight version of Teiid, it contain an easy-to-use JDBC Driver that can embed the Query Engine in any Java application. The Embedded mode supply almost all Teiid features without JEE Container involved, it supply a convenient way for Users who want integrate Teiid with their Application.

This document show how Teiid Embedded use OpenLDAP as data source, the architecture as below:

![teiid-embed-ldap]({{ site.baseurl }}/assets/blog/teiid-embed-ldap.png)

## OpenLDAP

[Java on top of LDAP](http://ksoong.org/ldap-java/) including OpenLDAP install, configure, etc. It also have example Groupd `HR` have 3 Users under it, This article use that example Group.

## ldapVDB VDB

A Virtual Database (VDB) is an artifact that defines the logical schema model combining one or more physical data sources to provide easy data integration. In this example, ldapVDB VDB has Model `HRModel` point to OpenLDAP. 

[The completed content of HRModel VDB](https://github.com/jbosschina/teiid-embedded-samples/blob/master/vdb/ldap-vdb.xml)

## JVM

Java Application run on JVM, load the `HRModel VDB` and query via JDBC. The mainly Code Snippets:

~~~
init("translator-mongodb", new LDAPExecutionFactory());
		
LDAPManagedConnectionFactory managedconnectionFactory = new LDAPManagedConnectionFactory();
managedconnectionFactory.setLdapUrl("ldap://10.66.218.46:389");
managedconnectionFactory.setLdapAdminUserDN("cn=Manager,dc=example,dc=com");
managedconnectionFactory.setLdapAdminUserPassword("redhat");
server.addConnectionFactory("java:/ldapDS", managedconnectionFactory.createConnectionFactory());
		
start(false);
server.deployVDB(new FileInputStream(new File("vdb/ldap-vdb.xml")));
conn = server.getDriver().connect("jdbc:teiid:ldapVDB", null);
~~~

[Completed Source code](https://github.com/jbosschina/teiid-embedded-samples/blob/master/src/test/java/com/teiid/embedded/samples/ldap/TestLDAPDataSource.java)

