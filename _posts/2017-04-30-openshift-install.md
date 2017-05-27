---
layout: blog
title:  "OpenShift Origin I - Quick Installation"
date:   2017-04-30 15:00:00
categories: openshift
permalink: /openshift-1
author: Kylin Soong
excerpt: OpenShift Origin Installation
---

* Table of contents
{:toc}

## Planning

### Two Installation Methods

![Two Installation Methods]({{ site.baseurl }}/assets/blog/openshift/openshift-2-inteall-methods.png)

### Sizing Considerations for OpenShift Origin cluster

![Sizing Considerations]({{ site.baseurl }}/assets/blog/openshift/openshift-sizing-consideration.png)

### Environment Scenarios

#### Single Master and Multiple Nodes

![Single Master and Multiple Nodes]({{ site.baseurl }}/assets/blog/openshift/openshift-env-scenario-1.png)

#### Single Master, Multiple etcd, and Multiple Nodes

![Single Master, Multiple etcd, and Multiple Nodes]({{ site.baseurl }}/assets/blog/openshift/openshift-env-scenario-2.png)

#### Multiple Masters Using Native HA

![Multiple Masters Using Native HA]({{ site.baseurl }}/assets/blog/openshift/openshift-env-scenario-3.png)

## Prerequisites

### SELinux

Security-Enhanced Linux (SELinux) must be enabled on all of the servers before installing OpenShift Origin or the installer will fail

~~~
# cat /etc/selinux/config 

# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.
SELINUX=enforcing
# SELINUXTYPE= can take one of these three values:
#     targeted - Targeted processes are protected,
#     minimum - Modification of targeted policy. Only selected processes are protected. 
#     mls - Multi Level Security protection.
SELINUXTYPE=targeted 
~~~

### Docker

~~~
# yum install docker
# docker version
~~~

## Installing 

### Download

~~~
# wget https://github.com/openshift/origin/releases/download/v3.6.0-alpha.0/openshift-origin-server-v3.6.0-alpha.0-0343989-linux-64bit.tar.gz
~~~

### Install

~~~
tar -xvf openshift-origin-server-v3.6.0-alpha.0-0343989-linux-64bit.tar.gz
~~~

### Set to path

~~~
PATH=$PATH:~/openshift/openshift-origin-server-v3.6.0-alpha.0-0343989-linux-64bit
~~~

## Running

### Start Docker Service

~~~
# systemctl start docker.service
# systemctl status docker.service
~~~

### Start OpenShift

~~~
# openshift start
~~~

### Web Console Walkthrough

Login Web Console [https://localhost:8443/console](https://localhost:8443/console) via either `system`/`admin`, or `test`/`test`.

### CLI Walkthrough

//TODO--

## Troubleshoot the installation

### how to add Docker daemon option insecure-registry in Fedora

Edit `/etc/docker/daemon.json` add --insecure-registry as bellow

~~~
{
    "insecure-registries": ["172.30.0.0/16"]
}
~~~


## Links

* [https://docs.openshift.org/latest/welcome/index.html](https://docs.openshift.org/latest/welcome/index.html)
* [https://docs.openshift.org/latest/getting_started/administrators.html](https://docs.openshift.org/latest/getting_started/administrators.html)
