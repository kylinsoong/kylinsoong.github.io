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
deploy adminapi-test-vdb.xml
undeploy adminapi-test-vdb.xml

/subsystem=teiid:restart-vdb(vdb-name=AdminAPITestVDB, vdb-version=1, model-names=TestModel)

/subsystem=teiid:list-vdbs()
/subsystem=teiid:get-vdb(vdb-name=AdminAPITestVDB,vdb-version=1)
/subsystem=teiid:change-vdb-connection-type(vdb-name=AdminAPITestVDB, vdb-version=1,connection-type=ANY)

/subsystem=teiid:add-data-role(vdb-name=AdminAPITestVDB, vdb-version=1, data-role=TestDataRole, mapped-role=test)
/subsystem=teiid:remove-data-role(vdb-name=AdminAPITestVDB, vdb-version=1, data-role=TestDataRole, mapped-role=test)
~~~

### Operate Source

~~~
/subsystem=teiid:add-source(vdb-name=AdminAPITestVDB, vdb-version=1, source-name=text-connector-test, translator-name=file, model-name=TestModel, ds-name=java:/test-file)
/subsystem=teiid:remove-source(vdb-name=AdminAPITestVDB, vdb-version=1, source-name=text-connector-test, model-name=TestModel)
/subsystem=teiid:update-source(vdb-name=AdminAPITestVDB, vdb-version=1, source-name=text-connector-test, translator-name=file, ds-name=java:/marketdata-file)
~~~

### Operate Translator

~~~
/subsystem=teiid:list-translators()
/subsystem=teiid:get-translator(translator-name=file)
/subsystem=teiid:read-translator-properties(translator-name=file,type=OVERRIDE)
/subsystem=teiid:read-rar-description(rar-name=file)
~~~

### Operate Runtime

~~~
/subsystem=teiid:workerpool-statistics()

/subsystem=teiid:cache-types()
/subsystem=teiid:clear-cache(cache-type=PREPARED_PLAN_CACHE)
/subsystem=teiid:clear-cache(cache-type=QUERY_SERVICE_RESULT_SET_CACHE)
/subsystem=teiid:clear-cache(cache-type=PREPARED_PLAN_CACHE, vdb-name=AdminAPITestVDB,vdb-version=1)
/subsystem=teiid:clear-cache(cache-type=QUERY_SERVICE_RESULT_SET_CACHE, vdb-name=AdminAPITestVDB,vdb-version=1)
/subsystem=teiid:cache-statistics(cache-type=PREPARED_PLAN_CACHE)
/subsystem=teiid:cache-statistics(cache-type=QUERY_SERVICE_RESULT_SET_CACHE)

/subsystem=teiid:engine-statistics()

/subsystem=teiid:list-sessions()
/subsystem=teiid:terminate-session(session=sessionid)

/subsystem=teiid:list-requests()
/subsystem=teiid:cancel-request(session=sessionId, execution-id=1)
/subsystem=teiid:list-requests-per-session(session=sessionId)
/subsystem=teiid:list-transactions()

/subsystem=teiid:mark-datasource-available(ds-name=java:/accounts-ds)

/subsystem=teiid:get-query-plan(session=sessionid,execution-id=1)
~~~
