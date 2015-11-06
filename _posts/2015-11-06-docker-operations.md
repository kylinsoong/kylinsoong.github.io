---
layout: blog
title:  "Docker Operations"
date:   2015-11-06 16:30:12
categories: docker
author: Kylin Soong
duoshuoid: ksoong2015110602
excerpt: This article covers topics to help you operate a Dockerized application environment. From understanding Docker Orchestration with Machine, Swarm and Compose, to security best practices and troubleshooting Docker containers.
---

The contents/commands come from Self-Paced Online Learning in [https://training.docker.com/self-paced-training](https://training.docker.com/self-paced-training).

* Check container logs

~~~
$ docker run -d -P tomcat:7
$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS                     NAMES
8835fbdd25de        tomcat:7            "catalina.sh run"   48 seconds ago      Up 47 seconds       0.0.0.0:32769->8080/tcp   cocky_poitras
$ docker logs cocky_poitras
$ mkdir logs
$ docker run -d -P -v /home/kylin/work/docker/testlogs:/var/log/nginx nginx
$ cd /home/kylin/work/docker/test/logs/
$ ls
access.log  error.log
~~~

* Docker inspect

~~~
$ docker ps 
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                                           NAMES
a215e83a4433        nginx               "nginx -g 'daemon off"   6 minutes ago       Up 6 minutes        0.0.0.0:32773->80/tcp, 0.0.0.0:32772->443/tcp   evil_engelbart
$ docker inspect evil_engelbart
$ docker inspect --format {{.NetworkSettings.IPAddress}} evil_engelbart
$ docker inspect evil_engelbart | grep IPAddres
~~~

* Starting and Stopping Docker daemon

~~~
//use service
# service docker stop
# service docker start
# service docker restart
# service docker status

//no use service
# docker -d &

//stop
# pidof docker
25880
# kill 25880
~~~

* Setup daemon logging

~~~
# docker -d --log-level=debug
~~~


