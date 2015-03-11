---
layout: blog
title:  "How Teiid be deployed on JBoss"
date:   2015-03-11 16:32:00
categories: teiid
permalink: /teiid-deploy-jboss
author: Kylin Soong
duoshuoid: ksoong2015031102
---

## Deploy Teiid upstream on JBoss

* Install JBoss Server

~~~
$ unzip jboss-eap-6.3.0.zip
~~~

* Build `jboss-dist`

~~~
$ git clone https://github.com/<yourname>/teiid.git
$ cd teiid
$ mvn clean install -Dmaven.test.skip=true -P release -s settings.xml
~~~

the `jboss-dist` will be generated in the "teiid/build/target" directory.

* Deploy `jboss-dist`

~~~
$ unzip teiid-8.11.0.Alpha1-SNAPSHOT-jboss-dist.zip -d jboss-eap-6.3.0
~~~

* Run `jboss-dist`

~~~
$ cd jboss-eap-6.3/
$ $ ./bin/standalone.sh -c standalone-teiid.xml
~~~

Teill will start and listen on 31000 for JDBC, 35432 for ODBC.

## What Teiid has beed added in configuration file

~~~
<?xml version='1.0' encoding='UTF-8'?>
<server xmlns="urn:jboss:domain:1.6">
    <extensions>
        <extension module="org.jboss.teiid"/>
    </extensions>
    <profile>
        <subsystem xmlns="urn:jboss:domain:datasources:1.2">
            <datasources>
                <drivers>
                    <driver name="teiid-local" module="org.jboss.teiid">
                        <driver-class>org.teiid.jdbc.TeiidDriver</driver-class>
                        <xa-datasource-class>org.teiid.jdbc.TeiidDataSource</xa-datasource-class>
                    </driver>
                    <driver name="teiid" module="org.jboss.teiid.client">
                        <driver-class>org.teiid.jdbc.TeiidDriver</driver-class>
                        <xa-datasource-class>org.teiid.jdbc.TeiidDataSource</xa-datasource-class>
                    </driver> 
                </drivers>
            </datasources>
        </subsystem>
        <subsystem xmlns="urn:jboss:domain:infinispan:1.5">
            <cache-container name="teiid" default-cache="resultset">
                <local-cache name="resultset">
                	<transaction mode="NON_XA"/>
                    <expiration lifespan="7200000" />
                    <eviction max-entries="1024" strategy="LIRS"/>
                </local-cache>
                <local-cache name="resultset-repl">
	                <transaction mode="NON_XA"/>
                    <expiration lifespan="7200000" />
                    <eviction max-entries="1024" strategy="LIRS"/>
                </local-cache>                
                <local-cache name="preparedplan">
                    <expiration lifespan="28800" />
                    <eviction max-entries="512" strategy="LIRS"/>
                </local-cache>  
            </cache-container>            
        </subsystem>
        <subsystem xmlns="urn:jboss:domain:resource-adapters:1.1">
            <resource-adapters>
                <resource-adapter id="file">
                    <module slot="main" id="org.jboss.teiid.resource-adapter.file"/>
                </resource-adapter>
                <resource-adapter id="google">
                    <module slot="main" id="org.jboss.teiid.resource-adapter.google"/>
                </resource-adapter>
                <resource-adapter id="ldap">
                    <module slot="main" id="org.jboss.teiid.resource-adapter.ldap"/>
                </resource-adapter>
                <resource-adapter id="salesforce">
                    <module slot="main" id="org.jboss.teiid.resource-adapter.salesforce"/>
                </resource-adapter>
                <resource-adapter id="webservice">
                    <module slot="main" id="org.jboss.teiid.resource-adapter.webservice"/>
                </resource-adapter>
                <resource-adapter id="mongodb">
                    <module slot="main" id="org.jboss.teiid.resource-adapter.mongodb"/>
                </resource-adapter>
                <resource-adapter id="cassandra">
                    <module slot="main" id="org.jboss.teiid.resource-adapter.cassandra"/>
                </resource-adapter>
		<resource-adapter id="simpledb">
                    <module slot="main" id="org.jboss.teiid.resource-adapter.simpledb"/>
                </resource-adapter>
                <resource-adapter id="accumulo">
                    <module slot="main" id="org.jboss.teiid.resource-adapter.accumulo"/>
                </resource-adapter>
                <resource-adapter id="solr">
                    <module slot="main" id="org.jboss.teiid.resource-adapter.solr"/>
                </resource-adapter>
            </resource-adapters>        
        </subsystem>
        <subsystem xmlns="urn:jboss:domain:security:1.2">
            <security-domains>
                <security-domain name="teiid-security" cache-type="default">
                    <authentication>
                        <login-module code="RealmDirect" flag="required">
                           <module-option name="password-stacking" value="useFirstPass"/>
                        </login-module>
                    </authentication>
                </security-domain>                
            </security-domains>
        </subsystem>
        <subsystem xmlns="urn:jboss:domain:teiid:1.0">
            <async-thread-pool>teiid-async</async-thread-pool>
            <resultset-cache infinispan-container="teiid" name="resultset"/>
            <preparedplan-cache infinispan-container="teiid" name="preparedplan"/>
            
            <transport name="embedded"/>
            <transport name="odata">
                <authentication security-domain="teiid-security"/>
            </transport>
            <transport name="jdbc" protocol="teiid" socket-binding="teiid-jdbc">
                <authentication security-domain="teiid-security"/>
            </transport>
            <transport name="odbc" protocol="pg" socket-binding="teiid-odbc">
                <authentication security-domain="teiid-security"/>
                <ssl mode="disabled"/>
            </transport>
            <policy-decider-module>org.jboss.teiid</policy-decider-module>        
            <translator name="jdbc-simple" module="org.jboss.teiid.translator.jdbc"/>
            <translator name="jdbc-ansi" module="org.jboss.teiid.translator.jdbc"/>
            <translator name="access" module="org.jboss.teiid.translator.jdbc"/>
            <translator name="db2" module="org.jboss.teiid.translator.jdbc"/>
            <translator name="derby" module="org.jboss.teiid.translator.jdbc"/>
            <translator name="h2" module="org.jboss.teiid.translator.jdbc"/>
            <translator name="hsql" module="org.jboss.teiid.translator.jdbc"/>
            <translator name="informix" module="org.jboss.teiid.translator.jdbc"/>
            <translator name="metamatrix" module="org.jboss.teiid.translator.jdbc"/>
            <translator name="mysql" module="org.jboss.teiid.translator.jdbc"/>
            <translator name="mysql5" module="org.jboss.teiid.translator.jdbc"/>
            <translator name="oracle" module="org.jboss.teiid.translator.jdbc"/>
            <translator name="postgresql" module="org.jboss.teiid.translator.jdbc"/>
            <translator name="sqlserver" module="org.jboss.teiid.translator.jdbc"/>
            <translator name="sybase" module="org.jboss.teiid.translator.jdbc"/>
            <translator name="sybaseiq" module="org.jboss.teiid.translator.jdbc"/>
            <translator name="teiid" module="org.jboss.teiid.translator.jdbc"/>
            <translator name="teradata" module="org.jboss.teiid.translator.jdbc"/>
            <translator name="modeshape" module="org.jboss.teiid.translator.jdbc"/>
            <translator name="ingres" module="org.jboss.teiid.translator.jdbc"/>
            <translator name="ingres93" module="org.jboss.teiid.translator.jdbc"/>
            <translator name="intersystems-cache" module="org.jboss.teiid.translator.jdbc"/>
            <translator name="netezza" module="org.jboss.teiid.translator.jdbc"/>
            <translator name="file" module="org.jboss.teiid.translator.file"/>
            <translator name="google-spreadsheet" module="org.jboss.teiid.translator.google"/>
            <translator name="ldap" module="org.jboss.teiid.translator.ldap"/>
            <translator name="loopback" module="org.jboss.teiid.translator.loopback"/>
            <translator name="olap" module="org.jboss.teiid.translator.olap"/>
            <translator name="ws" module="org.jboss.teiid.translator.ws"/>
            <translator name="salesforce" module="org.jboss.teiid.translator.salesforce"/>
            <translator name="hive" module="org.jboss.teiid.translator.hive"/>
            <translator name="jpa2" module="org.jboss.teiid.translator.jpa"/>
            <translator name="map-cache" module="org.jboss.teiid.translator.object"/>
            <translator name="odata" module="org.jboss.teiid.translator.odata"/>
            <translator name="sap-gateway" module="org.jboss.teiid.translator.odata"/>
            <translator name="sap-nw-gateway" module="org.jboss.teiid.translator.odata"/>
            <translator name="mongodb" module="org.jboss.teiid.translator.mongodb"/>
            <translator name="cassandra" module="org.jboss.teiid.translator.cassandra"/>
	    <translator name="simpledb" module="org.jboss.teiid.translator.simpledb"/>
            <translator name="accumulo" module="org.jboss.teiid.translator.accumulo"/>
            <translator name="solr" module="org.jboss.teiid.translator.solr"/>
            <translator name="excel" module="org.jboss.teiid.translator.excel"/>
            <translator name="impala" module="org.jboss.teiid.translator.hive"/>
            <translator name="prestodb" module="org.jboss.teiid.translator.prestodb"/>
            <translator name="hbase" module="org.jboss.teiid.translator.hbase"/>
        </subsystem>         
        <subsystem xmlns="urn:jboss:domain:threads:1.1">
            <unbounded-queue-thread-pool name="teiid-async">
                <max-threads count="4"/>
            </unbounded-queue-thread-pool>        
        </subsystem>
    </profile>
    <socket-binding-group name="standard-sockets" default-interface="public" port-offset="${jboss.socket.binding.port-offset:0}">
        <socket-binding name="teiid-jdbc" port="31000"/>
        <socket-binding name="teiid-odbc" port="35432"/>        
    </socket-binding-group>
</server>
~~~

As above configuration file, Teiid add the following in configuration file:

* Teiid extension - which point to module `org.jboss.teiid`
* Data Source Drivers - Teiid add 2 drivers `teiid-local` and `teiid` under datasources subsystem
* Infinispan Local cache - Teiid add 2 local cache `resultset`, `resultset-repl` and `preparedplan` under infinispan subsystem
* Resource Adapters - Teiid add a series resource adapters including `file`, `google`, `ldap`, `salesforce`, `webservice`, etc
* Security Domain - Teiid add security domain `teiid-security` under security subsystem
* Teiid subsystem - The teiid subsystem main logics of Teiid, like jdbc/odbc transport, translators, etc.
* Thread Pool - Teiid add unbounded-queue-thread-pool `teiid-async` under threads subsystem
* Socket binding port - Teiid add 2 socket-binding `teiid-jdbc` and `teiid-odbc`, it listen on 31000 and 35432 correspondingly.

