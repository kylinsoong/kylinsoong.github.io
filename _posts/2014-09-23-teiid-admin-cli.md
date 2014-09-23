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

## Operate VDB

~~~
/subsystem=teiid:get-vdb(vdb-name="ModeShape",vdb-version="1")
/subsystem=teiid:change-vdb-connection-type(vdb-name="ModeShape", vdb-version=1,connection-type="ANY")
/subsystem=teiid:restart-vdb(vdb-name="ModeShape", vdb-version=1)
~~~
