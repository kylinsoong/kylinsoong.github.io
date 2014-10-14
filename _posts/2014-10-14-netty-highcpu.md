---
layout: blog
title:  "Netty High CPU Issue"
date:   2014-10-14 17:25:30
categories: netty
permalink: /netty-highcpu
author: Kylin Soong
duoshuoid: ksoong2014101401
---

Today I debug the teiid code(teiid use netty 3.6.2) hit the Netty High CPU issue, The issue can be reproduced via the following code snippets:

~~~
	public static void main(String[] args) throws InterruptedException {

		ExecutorService nettyPool = Executors.newCachedThreadPool();
		ChannelFactory factory = new NioServerSocketChannelFactory(nettyPool, nettyPool, 1);
		ServerBootstrap bootstrap = new ServerBootstrap(factory);
		bootstrap.setPipelineFactory(new ChannelPipelineFactory() {

			public ChannelPipeline getPipeline() throws Exception {
				return Channels.pipeline(new SimpleChannelHandler());
			}});
		bootstrap.setOption("keepAlive", Boolean.TRUE);
		Channel serverChanel = bootstrap.bind(new InetSocketAddress(0));
		
		serverChanel.close();
		nettyPool.shutdownNow();
		
		Thread.currentThread().sleep(Long.MAX_VALUE);
	}
~~~

After above code ran, 2 threads(netty boss threads and netty worker threads) consume 100% cpu, the stacktrace as below:

~~~
"New I/O server boss #2" prio=10 tid=0x00007f7848194000 nid=0x3db7 runnable [0x00007f78448a2000]
   java.lang.Thread.State: RUNNABLE
	at sun.nio.ch.EPollArrayWrapper.interrupt(Native Method)
	at sun.nio.ch.EPollArrayWrapper.interrupt(EPollArrayWrapper.java:317)
	at sun.nio.ch.EPollSelectorImpl.wakeup(EPollSelectorImpl.java:193)
	- locked <0x00000000d7b6bcd0> (a java.lang.Object)
	at java.nio.channels.spi.AbstractSelector$1.interrupt(AbstractSelector.java:210)
	at java.nio.channels.spi.AbstractSelector.begin(AbstractSelector.java:216)
	at sun.nio.ch.EPollSelectorImpl.doSelect(EPollSelectorImpl.java:78)
	at sun.nio.ch.SelectorImpl.lockAndDoSelect(SelectorImpl.java:87)
	- locked <0x00000000d7b6bcc0> (a sun.nio.ch.Util$2)
	- locked <0x00000000d7b6bcb0> (a java.util.Collections$UnmodifiableSet)
	- locked <0x00000000d7b6bb98> (a sun.nio.ch.EPollSelectorImpl)
	at sun.nio.ch.SelectorImpl.select(SelectorImpl.java:98)
	at sun.nio.ch.SelectorImpl.select(SelectorImpl.java:102)
	at org.jboss.netty.channel.socket.nio.NioServerBoss.select(NioServerBoss.java:163)
	at org.jboss.netty.channel.socket.nio.AbstractNioSelector.run(AbstractNioSelector.java:206)
	at org.jboss.netty.channel.socket.nio.NioServerBoss.run(NioServerBoss.java:42)
	at org.jboss.netty.util.ThreadRenamingRunnable.run(ThreadRenamingRunnable.java:108)
	at org.jboss.netty.util.internal.DeadLockProofWorker$1.run(DeadLockProofWorker.java:42)
	at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1145)
	at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:615)
	at java.lang.Thread.run(Thread.java:745)

   Locked ownable synchronizers:
	- <0x00000000d7b6d058> (a java.util.concurrent.ThreadPoolExecutor$Worker)

"New I/O worker #1" prio=10 tid=0x00007f784815c000 nid=0x3db6 runnable [0x00007f78449a3000]
   java.lang.Thread.State: RUNNABLE
	at sun.nio.ch.EPollArrayWrapper.interrupt(Native Method)
	at sun.nio.ch.EPollArrayWrapper.interrupt(EPollArrayWrapper.java:317)
	at sun.nio.ch.EPollSelectorImpl.wakeup(EPollSelectorImpl.java:193)
	- locked <0x00000000d7b27f68> (a java.lang.Object)
	at java.nio.channels.spi.AbstractSelector$1.interrupt(AbstractSelector.java:210)
	at java.nio.channels.spi.AbstractSelector.begin(AbstractSelector.java:216)
	at sun.nio.ch.EPollSelectorImpl.doSelect(EPollSelectorImpl.java:78)
	at sun.nio.ch.SelectorImpl.lockAndDoSelect(SelectorImpl.java:87)
	- locked <0x00000000d7b27f58> (a sun.nio.ch.Util$2)
	- locked <0x00000000d7b27ed8> (a java.util.Collections$UnmodifiableSet)
	- locked <0x00000000d7b27ce0> (a sun.nio.ch.EPollSelectorImpl)
	at sun.nio.ch.SelectorImpl.select(SelectorImpl.java:98)
	at org.jboss.netty.channel.socket.nio.SelectorUtil.select(SelectorUtil.java:64)
	at org.jboss.netty.channel.socket.nio.AbstractNioSelector.select(AbstractNioSelector.java:409)
	at org.jboss.netty.channel.socket.nio.AbstractNioSelector.run(AbstractNioSelector.java:206)
	at org.jboss.netty.channel.socket.nio.AbstractNioWorker.run(AbstractNioWorker.java:88)
	at org.jboss.netty.channel.socket.nio.NioWorker.run(NioWorker.java:178)
	at org.jboss.netty.util.ThreadRenamingRunnable.run(ThreadRenamingRunnable.java:108)
	at org.jboss.netty.util.internal.DeadLockProofWorker$1.run(DeadLockProofWorker.java:42)
	at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1145)
	at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:615)
	at java.lang.Thread.run(Thread.java:745)

   Locked ownable synchronizers:
	- <0x00000000d7b3f488> (a java.util.concurrent.ThreadPoolExecutor$Worker)
~~~

> Notes: complete code as [HighCPUReproduce](https://github.com/kylinsoong/teiid-samples/blob/master/netty-samples/src/main/java/org/jboss/netty/highcpu/HighCPUReproduce.java).

## Resolution

After several times mail with Normal, this issue be fixed, pull request as [https://github.com/netty/netty/pull/2868](https://github.com/netty/netty/pull/2868).

Base on above pull request, [netty-3.6.10.Final](https://github.com/netty/netty/releases/tag/netty-3.6.10.Final) is a fixed release. 

If we change netty version to 3.6.10.Final

~~~
		<dependency>
			<groupId>io.netty</groupId>
			<artifactId>netty</artifactId>
			<version>3.6.10.Final</version>
		</dependency>
~~~ 

then run  [HighCPUReproduce](https://github.com/kylinsoong/teiid-samples/blob/master/netty-samples/src/main/java/org/jboss/netty/highcpu/HighCPUReproduce.java) again, the high cpu issed be fixed.
