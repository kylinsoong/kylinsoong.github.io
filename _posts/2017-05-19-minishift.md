---
layout: blog
title:  "Minishift Workshop"
date:   2017-05-19 21:00:00
categories: openshift
permalink: /minishift
author: Kylin Soong
excerpt:  Minishift Workshop(Install, Config, Deploy)
---

This workshop base on Fedora 25, Spring Boot 1.5.3.RELEASE.

* Table of contents
{:toc}

## Install

* Install KVM driver

~~~
$ sudo curl -L https://github.com/dhiltgen/docker-machine-kvm/releases/download/v0.7.0/docker-machine-driver-kvm -o /usr/local/bin/docker-machine-driver-kvm
$ sudo chmod +x /usr/local/bin/docker-machine-driver-kvm
~~~

More details refer to [https://docs.openshift.org/latest/minishift/getting-started/docker-machine-drivers.html#kvm-driver-install](https://docs.openshift.org/latest/minishift/getting-started/docker-machine-drivers.html#kvm-driver-install)

* Install Minishift

~~~
$ wget https://github.com/minishift/minishift/releases/download/v1.0.0/minishift-1.0.0-linux-amd64.tgz
$ tar -xvf minishift-1.0.0-linux-amd64.tgz
~~~

* Start Minishift

~~~
$ ./minishift start
~~~

> NOTE: In some scenerios, a `--docker-env` can be used to add some evn proerpties, eg, `minishift start --docker-env HTTP_PROXY=ADDR --docker-env HTTPS_PROXY=ADDRE`

> NOTE: The minishift start will download `minishift-b2d.iso`,
