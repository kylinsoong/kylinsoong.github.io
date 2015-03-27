---
layout: blog
title:  "Teiid Admin CLI Commands"
date:   2014-09-23 16:06:00
categories: teiid
permalink: /teiid-admin-cli
author: Kylin Soong
duoshuoid: ksoong2014092301
---

This docs contain a series useful commands for administrate Teiid Server.

### Operate VDB

~~~
/subsystem=teiid:list-vdbs()
/subsystem=teiid:get-vdb(vdb-name=AdminAPITestVDB,vdb-version=1)

~~~

### Operate Source

~~~
/subsystem=teiid:add-source(vdb-name=AdminAPITestVDB, vdb-version=1, source-name=text-connector-test, translator-name=file, model-name=TestModel, ds-name=java:/test-file)
/subsystem=teiid:remove-source(vdb-name=AdminAPITestVDB, vdb-version=1, source-name=text-connector-test, model-name=TestModel)
/subsystem=teiid:update-source(vdb-name=AdminAPITestVDB, vdb-version=1, source-name=text-connector-test, translator-name=file, ds-name=java:/marketdata-file)
~~~
