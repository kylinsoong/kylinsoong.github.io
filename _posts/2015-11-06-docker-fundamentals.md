---
layout: blog
title:  "Docker Fundamentals"
date:   2015-11-06 11:30:12
categories: docker
author: Kylin Soong
duoshuoid: ksoong2015110601
excerpt: This article provides hands-on instruction for getting started using Docker. This includes how to create Dockerfiles, build, manage and distribute Docker images and configure Containers.
---

The contents/commands come from Self-Paced Online Learning in [https://training.docker.com/self-paced-training](https://training.docker.com/self-paced-training).

* Build New Image

~~~
$ docker run -i -t ubuntu:14.04 /bin/bash
root@71b780671c3f:/# apt-get install curl
$ docker commit 71b780671c3f kylin/curl:1.0
$ docker images
~~~

* Use New Image

~~~
$ docker run -i -t kylin/curl:1.0 /bin/bash
root@d07c1801d7a4:/# which curl
/usr/bin/curl
~~~

* Build image from Dockerfile

**Step.1** create Dockerfile with content

~~~
FROM ubuntu:14.04
RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y vim
~~~

**Step.2** build

~~~
$ docker build -t kylin/testimage:1.0 .
~~~

**Step.3** verify and test

~~~
$ docker images
$ docker run -it kylin/testimage:1.0 /bin/bash
root@d0d80495620a:/# vim test
~~~

**Step.4** Write Dockerfile with aggregate way

~~~
FROM ubuntu:14.04
RUN apt-get update && apt-get install -y curl \
                                         vim
~~~

