---
layout: blog
title:  "HBase Connection Refused Issue"
date:   2014-12-02 14:45:00
categories: data
permalink: /hbase-connrefuse
author: Kylin Soong
duoshuoid: ksoong2014120201
excerpt: After installing HBase via quickstart 1.2.2, sometimes scann table
---

## Issue 

* After installing HBase via [quickstart 1.2.2](http://hbase.apache.org/book/quickstart.html), sometimes scann mytable in HBase shell throws the following error:

~~~
1.8.7-p357 :005 > scan 'Customer'
ROW                                                          COLUMN+CELL                                                                                                                                                                     
2014-12-01 15:51:25,158 INFO  [main] ipc.RpcClient: Retrying connect to server: localhost/127.0.0.1:40228 after sleeping 100ms. Already tried 0 time(s).
2014-12-01 15:51:25,259 INFO  [main] ipc.RpcClient: Retrying connect to server: localhost/127.0.0.1:40228 after sleeping 100ms. Already tried 1 time(s).
2014-12-01 15:51:25,361 INFO  [main] ipc.RpcClient: Retrying connect to server: localhost/127.0.0.1:40228 after sleeping 100ms. Already tried 2 time(s).
2014-12-01 15:51:27,922 INFO  [main] ipc.RpcClient: Retrying connect to server: localhost/127.0.0.1:40228 after sleeping 100ms. Already tried 0 time(s).
2014-12-01 15:51:28,023 INFO  [main] ipc.RpcClient: Retrying connect to server: localhost/127.0.0.1:40228 after sleeping 100ms. Already tried 1 time(s).
2014-12-01 15:51:28,125 INFO  [main] ipc.RpcClient: Retrying connect to server: localhost/127.0.0.1:40228 after sleeping 100ms. Already tried 2 time(s).
2014-12-01 15:51:30,249 INFO  [main] ipc.RpcClient: Retrying connect to server: localhost/127.0.0.1:40228 after sleeping 100ms. Already tried 0 time(s).
2014-12-01 15:51:30,350 INFO  [main] ipc.RpcClient: Retrying connect to server: localhost/127.0.0.1:40228 after sleeping 100ms. Already tried 1 time(s).
2014-12-01 15:51:30,452 INFO  [main] ipc.RpcClient: Retrying connect to server: localhost/127.0.0.1:40228 after sleeping 100ms. Already tried 2 time(s).
2014-12-01 15:51:33,202 INFO  [main] ipc.RpcClient: Retrying connect to server: localhost/127.0.0.1:40228 after sleeping 100ms. Already tried 0 time(s).
2014-12-01 15:51:33,303 INFO  [main] ipc.RpcClient: Retrying connect to server: localhost/127.0.0.1:40228 after sleeping 100ms. Already tried 1 time(s).
2014-12-01 15:51:33,404 INFO  [main] ipc.RpcClient: Retrying connect to server: localhost/127.0.0.1:40228 after sleeping 100ms. Already tried 2 time(s).
2014-12-01 15:51:35,521 INFO  [main] ipc.RpcClient: Retrying connect to server: localhost/127.0.0.1:40228 after sleeping 100ms. Already tried 0 time(s).
2014-12-01 15:51:35,623 INFO  [main] ipc.RpcClient: Retrying connect to server: localhost/127.0.0.1:40228 after sleeping 100ms. Already tried 1 time(s).
2014-12-01 15:51:35,724 INFO  [main] ipc.RpcClient: Retrying connect to server: localhost/127.0.0.1:40228 after sleeping 100ms. Already tried 2 time(s).
~~~

* Java Code as below invoke HBase client API throw the exception

~~~
Configuration conf = HBaseConfiguration.create();
HTable table = new HTable(conf, "Customer");
Get get = new Get("101".getBytes());
get.addFamily("customer".getBytes());
Result result = table.get(get);
~~~

[Error Log DEBUG](https://github.com/kylinsoong/data/blob/master/hbase-quickstart/connection-refused/error.log.debug)

[Error Log INFO](https://github.com/kylinsoong/data/blob/master/hbase-quickstart/connection-refused/error.log.info)

[Heap Dump](https://github.com/kylinsoong/data/blob/master/hbase-quickstart/connection-refused/tdump.out)

[Stackoverflow](http://stackoverflow.com/questions/27224195/ipc-rpcclient-retrying-connect-to-server-error-while-execute-scan-table-in-hb)


## Diagnostic Steps

Debug Issue Section Code get the following Diagram

![HBase HTabe Get Debug]({{ site.baseurl }}/assets/blog/HBase_3fysm846.png)

Base on Diagram, we can reproduce issue via the following code:

~~~
Configuration conf = HBaseConfiguration.create();
HConnection connection = HConnectionManager.getConnection(conf);
HTable metaTable = new HTable(TableName.META_TABLE_NAME, connection, null);
TableName tableName = TableName.valueOf("Customer");
byte[] row = "101".getBytes();
byte[] searchRow = HRegionInfo.createRegionName(tableName, row, HConstants.NINES, false);
Result startRowResult = metaTable.getRowOrBefore(searchRow, HConstants.CATALOG_FAMILY);
System.out.println(startRowResult);
~~~

Now the error stack trace become shorter:

~~~
Caused by: java.net.ConnectException: Connection refused
	at sun.nio.ch.SocketChannelImpl.checkConnect(Native Method)
	at sun.nio.ch.SocketChannelImpl.finishConnect(SocketChannelImpl.java:739)
	at org.apache.hadoop.net.SocketIOWithTimeout.connect(SocketIOWithTimeout.java:206)
	at org.apache.hadoop.net.NetUtils.connect(NetUtils.java:529)
	at org.apache.hadoop.net.NetUtils.connect(NetUtils.java:493)
	at org.apache.hadoop.hbase.ipc.RpcClient$Connection.setupConnection(RpcClient.java:578)
	at org.apache.hadoop.hbase.ipc.RpcClient$Connection.setupIOstreams(RpcClient.java:868)
	at org.apache.hadoop.hbase.ipc.RpcClient.getConnection(RpcClient.java:1543)
	at org.apache.hadoop.hbase.ipc.RpcClient.call(RpcClient.java:1442)
	at org.apache.hadoop.hbase.ipc.RpcClient.callBlockingMethod(RpcClient.java:1661)
	at org.apache.hadoop.hbase.ipc.RpcClient$BlockingRpcChannelImplementation.callBlockingMethod(RpcClient.java:1719)
	at org.apache.hadoop.hbase.protobuf.generated.ClientProtos$ClientService$BlockingStub.get(ClientProtos.java:30363)
	at org.apache.hadoop.hbase.protobuf.ProtobufUtil.getRowOrBefore(ProtobufUtil.java:1546)
	at org.apache.hadoop.hbase.client.HTable$2.call(HTable.java:717)
	at org.apache.hadoop.hbase.client.HTable$2.call(HTable.java:715)
	at org.apache.hadoop.hbase.client.RpcRetryingCaller.callWithRetries(RpcRetryingCaller.java:117)
	... 2 more
~~~

[Error Log Reproduce INFO](https://github.com/kylinsoong/data/blob/master/hbase-quickstart/connection-refused/error.log.reproduce.INFO) is show this explicitly.

## Resolution
