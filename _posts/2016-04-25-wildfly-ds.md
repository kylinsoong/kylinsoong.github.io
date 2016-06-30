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

> NOTE: module `org.mariadb.jdbc` be created, which should match `driver-module` in adding Driver. Download [module-remove-mariadb.cli]({{ site.baseurl }}/assets/download/cli/module-remove-mariadb.cli) to WildFly Home, removing module via execute `./bin/jboss-cli.sh --connect --file=module-remove-mariadb.cli`

### Add XA Data Source

Add XA Data Source relies upon [Add MariaDB Driver as a Module](#add-mariadb-driver-as-a-module), follow its directions to finish add driver module before continuing.

Download [create-mariadb-xa-ds.cli]({{ site.baseurl }}/assets/download/cli/create-mariadb-xa-ds.cli). Modify `driver-module`, `user-name`, `password`, `DatabaseName`, `PortNumber`, `ServerName` to match your scenarios, copy it to WildFly Home. Execute CLI below will create MariaDB XA Data Source in WildFly:

~~~
$ ./bin/jboss-cli.sh --connect --file=create-mariadb-xa-ds.cli
~~~

> NOTE: Download [remove-mariadb-xa-ds.cli]({{ site.baseurl }}/assets/download/cli/remove-mariadb-xa-ds.cli), copy it to WildFly Home, Execute `./bin/jboss-cli.sh --connect --file=remove-mariadb-xa-ds.cli` will remove `MariaDBXADS` which created above.

### Add non-XA Data Source

Add non-XA Data Source relies upon [Add MariaDB Driver as a Module](#add-mariadb-driver-as-a-module), follow its directions to finish add driver module before continuing.

Download [create-mariadb-ds.cli]({{ site.baseurl }}/assets/download/cli/create-mariadb-ds.cli). Modify `driver-module`, `user-name`, `password`, `connection-url` to match your scenarios, copy it to WildFly Home. Execute CLI below will add a non-XA Data Source in WildFly:

~~~
$ ./bin/jboss-cli.sh --connect --file=create-mariadb-ds.cli
~~~

> NOTE: Download [remove-mariadb-ds.cli]({{ site.baseurl }}/assets/download/cli/remove-mariadb-ds.cli), copy it to WildFly Home, Execute `./bin/jboss-cli.sh --connect --file=remove-mariadb-ds.cli` will remove `MariaDBDS` which created above.

## Mysql

[Download Driver](http://dev.mysql.com/downloads/connector/).

Alternatively, the maven dependency below can pull Mysql Driver.

~~~
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>5.1.38</version>
</dependency>
~~~

### Add Mysql Driver as a Module

Copy **mysql-connector-java-VERSION.jar** which downloaded above to WildFly Home.

Download [module-add-mysql.cli]({{ site.baseurl }}/assets/download/cli/module-add-mysql.cli) to WildFly Home, modify `--resources` to correct the driver version, execute CLI:

~~~
$ ./bin/jboss-cli.sh --connect --file=module-add-mysql.cli
~~~

> NOTE: module `com.mysql.jdbc` be created, which should match `driver-module` in adding Driver. Download [module-remove-mysql.cli]({{ site.baseurl }}/assets/download/cli/module-remove-mysql.cli) to WildFly Home, removing module via execute `./bin/jboss-cli.sh --connect --file=module-remove-mysql.cli`

### Add XA Data Source

Add XA Data Source relies upon [Add Mysql Driver as a Module](#add-mysql-driver-as-a-module), follow its directions to finish add driver module before continuing.

Download [create-mysql-xa-ds.cli]({{ site.baseurl }}/assets/download/cli/create-mysql-xa-ds.cli). Modify `driver-module`, `user-name`, `password`, `DatabaseName`, `PortNumber`, `ServerName` to match your scenarios, copy it to WildFly Home. Execute CLI below will create Mysql XA Data Source in WildFly:

~~~
$ ./bin/jboss-cli.sh --connect --file=create-mysql-xa-ds.cli
~~~

> NOTE: Download [remove-mysql-xa-ds.cli]({{ site.baseurl }}/assets/download/cli/remove-mysql-xa-ds.cli), copy it to WildFly Home, Execute `./bin/jboss-cli.sh --connect --file=remove-mysql-xa-ds.cli` will remove `MysqlXADS` which created above.

### Add non-XA Data Source

Add non-XA Data Source relies upon [Add Mysql Driver as a Module](#add-mysql-driver-as-a-module), follow its directions to finish add driver module before continuing.

Download [create-mysql-ds.cli]({{ site.baseurl }}/assets/download/cli/create-mysql-ds.cli). Modify `driver-module`, `user-name`, `password`, `connection-url` to match your scenarios, copy it to WildFly Home. Execute CLI below will add a non-XA Data Source in WildFly:

~~~
$ ./bin/jboss-cli.sh --connect --file=create-mysql-ds.cli
~~~

> NOTE: Download [remove-mysql-ds.cli]({{ site.baseurl }}/assets/download/cli/remove-mysql-ds.cli), copy it to WildFly Home, Execute `./bin/jboss-cli.sh --connect --file=remove-mysql-ds.cli` will remove `MysqlDS` which created above.

## H2

[Download Driver](http://www.h2database.com/html/download.html).

Alternatively, the maven dependency below can pull H2 Driver.

~~~
<dependency>
    <groupId>com.h2database</groupId>
    <artifactId>h2</artifactId>
    <version>1.4.192</version>
</dependency>
~~~

### Add H2 Driver as a Module

Copy **h2-VERSION.jar** which downloaded above to WildFly Home.

Download [module-add-h2.cli]({{ site.baseurl }}/assets/download/cli/module-add-h2.cli) to WildFly Home, modify `--resources` to correct the driver version, execute CLI:

~~~
$ ./bin/jboss-cli.sh --connect --file=module-add-h2.cli
~~~

> NOTE: module `org.h2.jdbc` be created, which should match `driver-module` in adding Driver. Download [module-remove-h2.cli]({{ site.baseurl }}/assets/download/cli/module-remove-h2.cli) to WildFly Home, removing module via execute `./bin/jboss-cli.sh --connect --file=remove-mariadb-ds.cli`

### Add XA Data Source

Add XA Data Source relies upon [Add H2 Driver as a Module](#add-h2-driver-as-a-module), follow its directions to finish add driver module before continuing.

Download [create-h2-xa-ds.cli]({{ site.baseurl }}/assets/download/cli/create-h2-xa-ds.cli). Modify `driver-module`, `user-name`, `password`, `URL` to match your scenarios, copy it to WildFly Home. Execute CLI below will create H2 XA Data Source in WildFly:

~~~
$ ./bin/jboss-cli.sh --connect --file=create-h2-xa-ds.cli
~~~

> NOTE: Download [remove-h2-xa-ds.cli]({{ site.baseurl }}/assets/download/cli/remove-h2-xa-ds.cli), copy it to WildFly Home, Execute `./bin/jboss-cli.sh --connect --file=remove-h2-xa-ds.cli` will remove `H2XADS` which created above.

### Add non-XA Data Source

Add non-XA Data Source relies upon [Add H2 Driver as a Module](#add-h2-driver-as-a-module), follow its directions to finish add driver module before continuing.

Download [create-h2-ds.cli]({{ site.baseurl }}/assets/download/cli/create-h2-ds.cli). Modify `driver-module`, `user-name`, `password`, `connection-url` to match your scenarios, copy it to WildFly Home. Execute CLI below will add a non-XA Data Source in WildFly:

~~~
$ ./bin/jboss-cli.sh --connect --file=create-h2-ds.cli
~~~

> NOTE: Download [remove-h2-ds.cli]({{ site.baseurl }}/assets/download/cli/remove-h2-ds.cli), copy it to WildFly Home, Execute `./bin/jboss-cli.sh --connect --file=remove-h2-ds.cli` will remove `H2DS` which created above.

## Teiid

[Download Driver](http://teiid.jboss.org/downloads/).

Alternatively, the maven dependency below can pull Teiid Driver.

~~~
<dependency>
    <groupId>org.jboss.teiid</groupId>
    <artifactId>teiid</artifactId>
    <version>9.0.0.Final</version>
    <classifier>jdbc</classifier>
</dependency>
~~~

### Add Teiid Driver as a Module

Copy **teiid-VERSION-jdbc.jar** which downloaded above to WildFly Home.

Download [module-add-teiid.cli]({{ site.baseurl }}/assets/download/cli/module-add-teiid.cli) to WildFly Home, modify `--resources` to correct the driver version, execute CLI:

~~~
$ ./bin/jboss-cli.sh --connect --file=module-add-teiid.cli
~~~

> NOTE: module `org.teiid.jdbc` be created, which should match `driver-module` in adding Driver. Download [module-remove-teiid.cli]({{ site.baseurl }}/assets/download/cli/module-remove-teiid.cli) to WildFly Home, removing module via execute `./bin/jboss-cli.sh --connect --file=module-remove-teiid.cli`

### Add XA Data Source

Add XA Data Source relies upon [Add Teiid Driver as a Module](#add-teiid-driver-as-a-module), follow its directions to finish add driver module before continuing.

Download [create-teiid-xa-ds.cli]({{ site.baseurl }}/assets/download/cli/create-teiid-xa-ds.cli). Modify `driver-module`, `user-name`, `password`, `DatabaseName`, `PortNumber`, `ServerName` to match your scenarios, copy it to WildFly Home. Execute CLI below will create Teiid XA Data Source in WildFly:

~~~
$ ./bin/jboss-cli.sh --connect --file=create-teiid-xa-ds.cli
~~~

> NOTE: Download [remove-teiid-xa-ds.cli]({{ site.baseurl }}/assets/download/cli/remove-teiid-xa-ds.cli), copy it to WildFly Home, Execute `./bin/jboss-cli.sh --connect --file=remove-teiid-xa-ds.cli` will remove `TeiidXADS` which created above.

### Add non-XA Data Source

Add non-XA Data Source relies upon [Add Teiid Driver as a Module](#add-teiid-driver-as-a-module), follow its directions to finish add driver module before continuing.

Download [create-teiid-ds.cli]({{ site.baseurl }}/assets/download/cli/create-teiid-ds.cli). Modify `driver-module`, `user-name`, `password`, `connection-url` to match your scenarios, copy it to WildFly Home. Execute CLI below will add a non-XA Data Source in WildFly:

~~~
$ ./bin/jboss-cli.sh --connect --file=create-teiid-ds.cli
~~~

> NOTE: Download [remove-teiid-ds.cli]({{ site.baseurl }}/assets/download/cli/remove-teiid-ds.cli), copy it to WildFly Home, Execute `./bin/jboss-cli.sh --connect --file=remove-teiid-ds.cli` will remove `TeiidDS` which created above.
