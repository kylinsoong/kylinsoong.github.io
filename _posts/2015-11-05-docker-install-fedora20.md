---
layout: blog
title:  "Install Docker on Fedora 20"
date:   2015-11-05 16:00:12
categories: docker
author: Kylin Soong
duoshuoid: ksoong2015110501
excerpt: The steps of install docker on Fedora 20
---

Following this article to instlla [docker](https://www.docker.com/) on Fedora 20.

* Docker requires a 64-bit installation,  kernel must be 3.10 at minimum:

~~~
# uname -r
3.11.10-301.fc20.x86_64
~~~ 

* Configure yum repo

~~~
# cat /etc/yum.repos.d/docker-main.repo 
[docker-main-repo]
name=Docker main Repository
baseurl=https://yum.dockerproject.org/repo/main/fedora/20
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
~~~

* Install the Docker package.

~~~
# yum install docker-engine
~~~

* Start Docker

~~~
# service docker start
~~~

* Verify docker is installed correctly

~~~
# docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
b901d36b6f2f: Pull complete 
0a6ba66e537a: Pull complete 
Digest: sha256:517f03be3f8169d84711c9ffb2b3235a4d27c1eb4ad147f6248c8040adb93113
Status: Downloaded newer image for hello-world:latest

Hello from Docker.
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker Hub account:
 https://hub.docker.com

For more examples and ideas, visit:
 https://docs.docker.com/userguide/
~~~
