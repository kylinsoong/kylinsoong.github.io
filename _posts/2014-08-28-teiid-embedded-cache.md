---
layout: blog
title:  "Teiid embedded samples Infnispan Local Cache"
date:   2014-08-28 16:00:00
categories: teiid
permalink: /teiid-embedded-cache
author: Kylin Soong
duoshuoid: ksoong2014082801
---

Teiid Embedded is a light-weight version of Teiid, it contain an easy-to-use JDBC Driver that can embed the Query Engine in any Java application. The Embedded mode supply almost all Teiid features without JEE Container involved, it supply a convenient way for Users who want integrate Teiid with their Application.

This document show how Teiid Embedded use Infnispan Local Cache as data source, the architecture as below:

![teiid-embed-cache]({{ site.baseurl }}/assets/blog/teiid-embed-cache.png)

## Infnispan Local Cache

Infnispan Local Cache be used in this example, The cache `local-quickstart-cache` be configured in [infinispan-config-local.xml](https://github.com/jbosschina/teiid-embedded-samples/blob/master/src/test/resources/infinispan-config-local.xml) 


## orders VDB

A Virtual Database (VDB) is an artifact that defines the logical schema model combining one or more physical data sources to provide easy data integration. In this example, orders VDB has Model `OrdersView` point to Infinispan Local Cache `local-quickstart-cache` 

[The completed content of orders VDB](https://github.com/jbosschina/teiid-embedded-samples/blob/master/vdb/infinispancache-vdb.xml)

## JVM

Java Application run on JVM, load the `orders VDB` and query via JDBC. The mainly Code Snippets:

~~~
	init("infinispan-local", new ObjectExecutionFactory());
		
	InfinispanManagedConnectionFactory managedConnectionFactory = new InfinispanManagedConnectionFactory();
	managedConnectionFactory.setConfigurationFileNameForLocalCache("src/test/resources/infinispan-config-local.xml");
	managedConnectionFactory.setCacheTypeMap(TEST_CACHE_NAME + ":" + Order.class.getName());
	server.addConnectionFactory("java:/infinispanTest", managedConnectionFactory.createConnectionFactory());
		
	start(false);
		
	loadCache(managedConnectionFactory);
		
	server.deployVDB(new FileInputStream(new File("vdb/infinispancache-vdb.xml")));
		
	conn = server.getDriver().connect("jdbc:teiid:orders", null);
~~~

[Completed Source code](https://github.com/jbosschina/teiid-embedded-samples/blob/master/src/test/java/com/teiid/embedded/samples/infinispan/TestInfinispanLocalCache.java)

