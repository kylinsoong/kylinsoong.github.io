---
layout: blog
title:  "Teiid embedded samples Infnispan Remote Cache"
date:   2014-08-28 22:10:00
categories: teiid
permalink: /teiid-embedded-grid
author: Kylin Soong
duoshuoid: ksoong2014082802
---

Teiid Embedded is a light-weight version of Teiid, it contain an easy-to-use JDBC Driver that can embed the Query Engine in any Java application. The Embedded mode supply almost all Teiid features without JEE Container involved, it supply a convenient way for Users who want integrate Teiid with their Application.

This document show how Teiid Embedded use Infnispan Remote Cache as data source, the architecture as below:

![teiid-embed-grid]({{ site.baseurl }}/assets/blog/teiid-embed-grid.png)

## Infnispan Remote Cache

Infnispan Remote Cache be used in this example, The cache `remote-quickstart-cache` be configured in Remote JBoss Data Grid Server, Infinispan Hot Rod protocol be used to load remote cache. 

For setup `remote-quickstart-cache` either use CLI commands:

~~~
/subsystem=infinispan/cache-container=local/local-cache=remote-quickstart-cache:add(start=EAGER)
~~~

or edit JBoss Data Grid configuration file standalone.xml, add the following in cache-container:

~~~
<local-cache name="remote-quickstart-cache" start="EAGER">
    <locking isolation="NONE" acquire-timeout="30000" concurrency-level="1000" striping="false"/>
    <transaction mode="NONE"/>
</local-cache>
~~~

For using Hot Rod Connection to JBoss Data Grid use the following properties:

~~~
infinispan.client.hotrod.server_list=10.66.218.46:11222
jdg.host=10.66.218.46
jdg.hotrod.port=11222
jdg.cache.name=remote-quickstart-cache
~~~

## remote_orders VDB

A Virtual Database (VDB) is an artifact that defines the logical schema model combining one or more physical data sources to provide easy data integration. In this example, remote_orders VDB has Model `OrdersView` point to Infinispan Remote Cache `remote-quickstart-cache` 

[The completed content of orders VDB](https://github.com/jbosschina/teiid-embedded-samples/blob/master/vdb/remotecache-vdb.xml)

## JVM

Java Application run on JVM, load the `remote_orders VDB` and query via JDBC. The mainly Code Snippets:

~~~
init("infinispan-remote", new ObjectExecutionFactory());
		
InfinispanManagedConnectionFactory managedConnectionFactory = new InfinispanManagedConnectionFactory();
managedConnectionFactory.setRemoteServerList(REMOTE_SERVE_LIST);
managedConnectionFactory.setCacheTypeMap(TEST_CACHE_NAME + ":" + Order.class.getName());
server.addConnectionFactory("java:/infinispanRemote", managedConnectionFactory.createConnectionFactory());
		
start(false);
		
server.deployVDB(new FileInputStream(new File("vdb/remotecache-vdb.xml")));
		
conn = server.getDriver().connect("jdbc:teiid:remote_orders", null);
~~~

[Completed Source code](https://github.com/jbosschina/teiid-embedded-samples/blob/master/src/test/java/com/teiid/embedded/samples/infinispan/TestInfinispanRemoteCache.java)

