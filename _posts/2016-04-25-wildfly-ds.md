---
layout: blog
title:  "WildFly Data Sources Configuration"
date:   2016-04-25 18:40:12
categories: jboss
permalink: /wfl-ds
author: Kylin Soong
duoshuoid: ksoong2016042601
excerpt: XA Data Sources, WildFly CLI, Mysql, Oracle, JDBC Driver, JNDI
---

* Table of contents
{:toc}

## MariaDB

[Download Driver](https://downloads.mariadb.org/connector-java/).

Alternatively, the maven dependency below can pull MariaDB Driver.

~~~
<dependency>
    <groupId>org.mariadb.jdbc</groupId>	
    <artifactId>mariadb-java-client</artifactId>
    <version>1.4.3</version>
</dependency>
~~~

### Add MariaDB Driver as a Module

Copy **mariadb-java-client-VERSION.jar** which downloaded above to WildFly Home.

Download [module-add-mariadb.cli]({{ site.baseurl }}/assets/download/cli/module-add-mariadb.cli) to WildFly Home, modify `--resources` to correct the driver version, execute CLI:

~~~
$ ./bin/jboss-cli.sh --connect --file=module-add-mariadb.cli
~~~

> NOTE: module `org.mariadb.jdbc` be created, which should match `driver-module` in adding Driver

Corresponding to add module, download [module-remove-mariadb.cli]({{ site.baseurl }}/assets/download/cli/module-remove-mariadb.cli) to WildFly Home, removing module via CLI:

~~~
$ ./bin/jboss-cli.sh --connect --file=module-remove-mariadb.cli
~~~

### Add XA Data Source

Download [create-mariadb-xa-ds.cli]({{ site.baseurl }}/assets/download/cli/create-mariadb-xa-ds.cli). Modify `driver-module`, `user-name`, `password`, `DatabaseName`, `PortNumber`, `ServerName` to match your scenarios, copy it to WildFly Home. Execute CLI below will create MariaDB XA Data Source in WildFly:

~~~
$ ./bin/jboss-cli.sh --connect --file=create-mariadb-xa-ds.cli
~~~

Corresponding to create, download [remove-mariadb-xa-ds.cli]({{ site.baseurl }}/assets/download/cli/remove-mariadb-xa-ds.cli), copy it to WildFly Home, Execute CLI below will remove `MariaDBXADS` which created above:

~~~
$ ./bin/jboss-cli.sh --connect --file=remove-mariadb-xa-ds.cli
~~~

### Add non-XA Data Source

Download [create-mariadb-ds.cli]({{ site.baseurl }}/assets/download/cli/create-mariadb-ds.cli). Modify `driver-module`, `user-name`, `password`, `connection-url` to match your scenarios, copy it to WildFly Home. Execute CLI below will add a non-XA Data Source in WildFly:

~~~
$ ./bin/jboss-cli.sh --connect --file=create-mariadb-ds.cli
~~~

Corresponding to create, download [remove-mariadb-ds.cli]({{ site.baseurl }}/assets/download/cli/remove-mariadb-ds.cli), copy it to WildFly Home, Execute CLI below will remove `MariaDBDS` which created above:

~~~
$ ./bin/jboss-cli.sh --connect --file=remove-mariadb-ds.cli
~~~



