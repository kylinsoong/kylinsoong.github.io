---
layout: blog
title:  "jBPM use LDAP replace default Plain-text"
date:   2017-01-14 17:35:12
categories: jbpm
permalink: /jbpm-openldap
author: Kylin Soong
duoshuoid: ksoong2017011402
excerpt: jBPM replease default Plain-text security tp OpenLdap
---

This section including how to configure jbpm-console to use LDAP for authentication and authorization of users.

* Change into WildFly Home, execute [create-security-domain-ldap.cli]({{ site.baseurl }}/assets/download/jbpm/create-security-domain-ldap.cli) 

~~~
./bin/jboss-cli.sh --connect --file=installation/create-security-domain-ldap.cli
~~~

* Edit `jbpm-console.war/WEB-INF/jboss-web.xml`, change security domain to `jbpm-cluster`

~~~
<jboss-web>
    <security-domain>jbpm-cluster</security-domain>
</jboss-web>
~~~

> NOTE: `admin`, `analyst`, `reviewer` are necessary in LDAP. 
