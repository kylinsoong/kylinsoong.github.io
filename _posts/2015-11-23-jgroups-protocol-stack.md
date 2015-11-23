---
layout: blog
title:  "jGroups 协议栈"
date:   2015-11-23 17:10:12
categories: jboss
author: Kylin Soong
duoshuoid: ksoong2015112301
---

jGroups 是一个可靠多播传输工具包，它能够为集群中成员提供点对点，点对组的通信，下图为 jGroups 架构图，所有通信通过通道完成。通道基于协议栈之上，协议栈中协议各自有自己特别的功能，这些功能综合起来使通道通道具有完成多波传输的能力。

![JGroups Architecture]({{ site.baseurl }}/assets/blog/jgroups-architecture.png)

本文来说明 jGroups 协议栈。

## jGroups 协议栈配置

jGroups 通道初始化需要指定协议栈配置文件，如下

~~~
JChannel channel = new JChannel("udp-stack.xml");
~~~

JChannel 初始化传入的参数为 `udp-stack.xml`（详细内容参照附录一)，具体过程如下图：

![JGroups JChannel init]({{ site.baseurl }}/assets/blog/jgroups-jchanel-init.png)

参照附录一，`udp-stack.xml` 中配置的协议共有16个，这16个协议组成一个协议栈，如下图：

![JGroups Protocol Stack]({{ site.baseurl }}/assets/blog/jgroups-protocol-stack.png)

图中有两条带箭头虚线，

* 1 为消息发送
* 2 为消息接收

不管消息的接收还是发送，消息都需要经过协议栈中所有协议按照出栈入栈的顺序进行处理.

如上协议栈中协议的 UML 图:

![JGroups Protocol UML]({{ site.baseurl }}/assets/blog/jgroups-protocols-uml.png)

## jGroups UDP 传输协议初始化

传输协议位于协议栈最底层，它负责从物理网络环境接收消息，将接收到的消息传递到协议栈中上层相邻的协议，以及将协议栈中上层协议传递下来的消息发送到物理网络。传输层协议主要包括UDP，TCP，TUNNEL。这些协议时独立的，在同一个协议栈中只能配置一个传输层协议。

下图以 UDP 为例，说明了传输协议初始化的过程

![JGroups Protocol udp]({{ site.baseurl }}/assets/blog/jgroups-protocol-udp-init.png)

## JChannel connect

JChannel connect 方法调运过程如下

![JGroups JChannel connect]({{ site.baseurl }}/assets/blog/jgroups-jchannel-connect.png)

## 附录一: jGroups 协议栈配置

~~~
<config xmlns="urn:org:jgroups"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="urn:org:jgroups http://www.jgroups.org/schema/jgroups.xsd">
    <UDP
         mcast_port="${jgroups.udp.mcast_port:45588}"
         ip_ttl="4"
         tos="8"
         ucast_recv_buf_size="20M"
         ucast_send_buf_size="1M"
         mcast_recv_buf_size="25M"
         mcast_send_buf_size="5M"
         max_bundle_size="64K"
         max_bundle_timeout="30"
         enable_diagnostics="true"
         thread_naming_pattern="cl"

         timer_type="new3"
         timer.min_threads="2"
         timer.max_threads="4"
         timer.keep_alive_time="3000"
         timer.queue_max_size="500"

         thread_pool.enabled="true"
         thread_pool.min_threads="2"
         thread_pool.max_threads="8"
         thread_pool.keep_alive_time="5000"
         thread_pool.queue_enabled="true"
         thread_pool.queue_max_size="10000"
         thread_pool.rejection_policy="discard"

         oob_thread_pool.enabled="true"
         oob_thread_pool.min_threads="1"
         oob_thread_pool.max_threads="8"
         oob_thread_pool.keep_alive_time="5000"
         oob_thread_pool.queue_enabled="false"
         oob_thread_pool.queue_max_size="100"
         oob_thread_pool.rejection_policy="discard"/>

    <PING />
    <MERGE3 max_interval="30000"
            min_interval="10000"/>
    <FD_SOCK/>
    <FD_ALL/>
    <VERIFY_SUSPECT timeout="1500"  />
    <BARRIER />
    <pbcast.NAKACK2 xmit_interval="500"
                    xmit_table_num_rows="100"
                    xmit_table_msgs_per_row="2000"
                    xmit_table_max_compaction_time="30000"
                    max_msg_batch_size="500"
                    use_mcast_xmit="false"
                    discard_delivered_msgs="true"/>
    <UNICAST3 xmit_interval="500"
              xmit_table_num_rows="100"
              xmit_table_msgs_per_row="2000"
              xmit_table_max_compaction_time="60000"
              conn_expiry_timeout="0"
              max_msg_batch_size="500"/>
    <pbcast.STABLE stability_delay="1000" desired_avg_gossip="50000"
                   max_bytes="4M"/>
    <pbcast.GMS print_local_addr="true" join_timeout="2000"
                view_bundling="true"/>
    <UFC max_credits="2M"
         min_threshold="0.4"/>
    <MFC max_credits="2M"
         min_threshold="0.4"/>
    <FRAG2 frag_size="60K"  />
    <RSVP resend_interval="2000" timeout="10000"/>
    <pbcast.STATE_TRANSFER />
    <!-- pbcast.FLUSH  /-->
</config>
~~~

> NOTE: 如上配置文件对应 jGroups 版本号为 3.6.x.
