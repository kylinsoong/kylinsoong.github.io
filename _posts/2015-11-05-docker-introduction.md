---
layout: blog
title:  "Introduction to Docker"
date:   2015-11-05 18:00:12
categories: docker
author: Kylin Soong
duoshuoid: ksoong2015110502
excerpt: This article covers the foundations of the Docker platform, including an overview of the platform components, images, containers and repositories.
---

The commands come from Self-Paced Online Learning in [https://training.docker.com/self-paced-training](https://training.docker.com/self-paced-training).

* Add a user to docker group:

~~~
# sudo usermod -aG docker kylin
~~~

* Docker version

~~~
# docker version
~~~

* Dispaly images

~~~
# docker images 
~~~

* Creating a Container

~~~
# docker run ubuntu:14.04 echo "hello world"

# docker run ubuntu:14.04 ps -aux
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  3.0  0.0  15560   984 ?        Rs   09:49   0:00 ps -aux
~~~

* Run a container and get Terminal Access

~~~
$ docker run -i -t ubuntu:14.04 /bin/bash
root@3e74dd26251f:/# adduser ksoong
root@3e74dd26251f:/# adduser ksoong sudo
$ docker run -i -t ubuntu:14.04 /bin/bash
~~~

* Docker container ID

~~~
$ docker ps
$ docker ps -a
~~~

* Run container in detached mode:

~~~
$ docker run -d ubuntu ping 127.0.0.1 -c 100
$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
70cde9a3a22b        ubuntu              "ping 127.0.0.1 -c 10"   13 seconds ago      Up 12 seconds                           pensive_babbage
$ docker logs 70cde9a3a22b
~~~

* Tomcat container

~~~
$ docker run -d -P tomcat:7
$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS                     NAMES
18bd96a1996c        tomcat:7            "catalina.sh run"   3 minutes ago       Up 3 minutes        0.0.0.0:32768->8080/tcp   sad_torvalds
~~~

[127.0.0.1:32768](127.0.0.1:32768)
