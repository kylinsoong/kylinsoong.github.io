---
layout: blog
title:  "HAProxy 实现 mysql 负载均衡"
date:   2017-09-29 19:00:00
categories: data
permalink: /haproxy-mysql
author: Kylin Soong
---

* Table of contents
{:toc}

HAProxy 是一款开源软件，可以基于 TCP 和 HTTP 进行负载均衡，本文通过 HAProxy 实现 mysql 负载均衡，具体架构如下：

![haproxy-mysql-architecture]({{ site.baseurl }}/assets/blog/2017/haproxy-mysql.png)

* HAProxy 的地址为 haproxy.node.com，TCP 端口为3306
* Mysql 1 的地址为 mysql.node1.com，TCP 端口为3306
* Mysql 2 的地址为 mysql.node2.com，TCP 端口为3306

基于 URL `jdbc:mysql://haproxy.node.com:3306/test` 创建数据库连接，执行 SQL 查询 `SELECT * FROM FOO`，SQL 请求会转发到后台数据库，haproxy 转发 SQL 请求有多种策略,本测试使用leastconn,实际生成中可以根据需求进行配置。 

## 在红帽企业版 Linux 7.4 上配置 HAProxy

使用如下步骤完成在红帽企业版 Linux 7.4 上配置 HAProxy：

### 系统准备

系统准备首先确定使用的操作系统为红帽企业版 Linux 7.4：

~~~
# cat /etc/redhat-release
Red Hat Enterprise Linux Server release 7.4 (Maipo)
~~~

其次是注册绑定帐号，确保更新安装软件包：

~~~
subscription-manager register --username YOURUSERNAME --password YOURPASSWORD
subscription-manager attach --auto
~~~

> 注意：如上操作在红帽企业版 Linux 7 所有版本均可以执行。本测试基于 7.4 版本。

### 安装 HAProxy

系统准备完成后执行如下命令安装 HAProxy:

~~~
# yum install haproxy
~~~

### 配置 Selinux 允许 haproxy 连接

~~~
# setsebool -P haproxy_connect_any 1
~~~

> 注意：在生产系统可以配置更严谨的安全控制策略。

### 配置 HAProxy

下载 [haproxy.cfg]({{ site.baseurl }}/assets/download/files/haproxy.cfg)，替换默认配置文件:

~~~
# cd /etc/haproxy/
# mv haproxy.cfg haproxy.cfg-bak
# cp ~/Downloads/haproxy.cfg ./
~~~

### 启动 HAProxy

执行如下命令，配置 HAProxy 开机启动、启动 HAProxy、查看 HAProxy 状态:

~~~
systemctl enable haproxy
systemctl start haproxy
systemctl status haproxy
~~~

正常启动情况，HAProxy 状态如下：

![haproxy-status]({{ site.baseurl }}/assets/blog/2017/haproxy-status.png)

### 查看 HAProxy 监听端口

执行 netstat 命令：

~~~
# netstat -antlop | grep haproxy
tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      22984/haproxy        off (0.00/0/0)
tcp        0      0 0.0.0.0:3306            0.0.0.0:*               LISTEN      22984/haproxy        off (0.00/0/0)
~~~

### 查看 HAProxy 统计数据

通过 http://127.0.0.1/haproxy URL 可以访问 HAProxy 统计数据数据页面，页面的登录用户名密码分别为 `admin`，`admin`。

![haproxy-statics]({{ site.baseurl }}/assets/blog/2017/haproxy-statics.png)

如上页面显示了前端代理和后台 Mysql 的状态，从上到下分别为：

* 前端 HTTP 代理
* 前端 JDBC 3306 端口代理
* 后台 HTTP 统计数据
* 后台 Mysql JDBC

## 测试访问

多次执行如下 SQL:

~~~
String JDBC_DRIVER = "com.mysql.jdbc.Driver";
String JDBC_URL = "jdbc:mysql://haproxy.node.com:3306/test";
String JDBC_USER = "test_user";
String JDBC_PASS = "redhat";

Connection conn = getDriverConnection(JDBC_DRIVER, JDBC_URL, JDBC_USER, JDBC_PASS);
execute(conn, "SELECT * FROM FOO", true);
~~~

我们可以看到 SQL 请求转发在两个节点上，达到负载均衡的目的。
