---
layout: blog
title:  "Kerberos KDC 配置与安装"
date:   2015-10-06 14:50:00
categories: data
permalink: /kerberos-kds-install
author: Kylin Soong
duoshuoid: ksoong2015100601
---

本问演示如何基于 Fedora 20 安装 Kerberos KDC 服务器。

**1.** 安装 krb5-libs krb5-server krb5-workstation 

~~~
yum -y install krb5-libs krb5-server krb5-workstation
~~~

**2.** 配置

编辑 /etc/krb5.conf，添加内容如下:

~~~
[logging]
 default = FILE:/var/log/krb5libs.log
 kdc = FILE:/var/log/krb5kdc.log
 admin_server = FILE:/var/log/kadmind.log

[libdefaults]
 dns_lookup_realm = false
 ticket_lifetime = 24h
 renew_lifetime = 7d
 forwardable = true
 rdns = false
 default_realm = EXAMPLE.COM
 default_ccache_name = KEYRING:persistent:%{uid}

[realms]
 EXAMPLE.COM = {
  kdc = 127.0.0.1:88
  admin_server = 127.0.0.1:749
 }

[domain_realm]
.example.com = EXAMPLE.COM
example.com = EXAMPLE.COM
~~~

编辑 /var/kerberos/krb5kdc/kdc.conf，确保 realm 名称映射正确:

~~~
[kdcdefaults]
 kdc_ports = 88
 kdc_tcp_ports = 88

[realms]
 EXAMPLE.COM = {
  #master_key_type = aes256-cts
  acl_file = /var/kerberos/krb5kdc/kadm5.acl
  dict_file = /usr/share/dict/words
  admin_keytab = /var/kerberos/krb5kdc/kadm5.keytab
  supported_enctypes = aes256-cts:normal aes128-cts:normal des3-hmac-sha1:normal arcfour-hmac:normal camellia256-cts:normal camellia128-cts:normal des-hmac-sha1:normal des-cbc-md5:normal des-cbc-crc:normal
 }
~~~

**3.** 使用 kdb5_util 创建初始化数据库

~~~
# /usr/sbin/kdb5_util create -s
Loading random data
Initializing database '/var/kerberos/krb5kdc/principal' for realm 'EXAMPLE.COM',
master key name 'K/M@EXAMPLE.COM'
You will be prompted for the database Master Password.
It is important that you NOT FORGET this password.
Enter KDC database master key: 
Re-enter KDC database master key to verify: 
~~~

**4.** 同步系统时间

~~~
# service ntpd restart 
~~~

**5.** 编辑 /var/kerberos/krb5kdc/kadm5.acl，添加内容如下

~~~
*/admin *
~~~

**6.** 创建初始化 principal

~~~
# /usr/sbin/kadmin.local -q "addprinc root/admin"
Authenticating as principal root/admin@EXAMPLE.COM with password.
WARNING: no policy specified for root/admin@EXAMPLE.COM; defaulting to no policy
Enter password for principal "root/admin@EXAMPLE.COM": 
Re-enter password for principal "root/admin@EXAMPLE.COM": 
Principal "root/admin@EXAMPLE.COM" created.
~~~

**7.** 配置 iptables

~~~
# iptables -F
# ip6tables -F
~~~

> NOTE: 为了方便测试，如上命令关闭了iptables。

**8.** 启动 kerberos

~~~
# /sbin/service krb5kdc start
# /sbin/service kadmin start
~~~
