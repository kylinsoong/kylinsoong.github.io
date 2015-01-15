---
layout: blog
title:  "Phoenix nanos > 999999999 or < 0"
date:   2014-01-15 22:45:00
categories: data
permalink: /phoenix-nanros
author: Kylin Soong
duoshuoid: ksoong20150115
---

Phoniex execute JDBC inter with Calendar like below:

~~~
		Calendar cal = Calendar.getInstance();
		cal.setTimeZone(TimeZone.getDefault());
		
		Timestamp timestramp = new Timestamp(new java.util.Date().getTime());
		String sql = "UPSERT INTO \"NanosTest\" (\"ROW_ID\", \"q\") VALUES (?, ?)";
		PreparedStatement pstmt = conn.prepareStatement(sql);
		
		pstmt.setString(1, "100");
		pstmt.setTimestamp(2, timestramp, cal);
		pstmt.addBatch();
		
		pstmt.executeBatch();
~~~

throw java.lang.IllegalArgumentException: nanos > 999999999 or < 0, the completed stacktrace like:

~~~
Exception in thread "main" java.lang.IllegalArgumentException: nanos > 999999999 or < 0
	at java.sql.Timestamp.setNanos(Timestamp.java:386)
	at org.apache.phoenix.util.DateUtil.getTimestamp(DateUtil.java:142)
	at org.apache.phoenix.jdbc.PhoenixPreparedStatement.setTimestamp(PhoenixPreparedStatement.java:489)
~~~

> note that, the create table DML like: CREATE TABLE IF NOT EXISTS "NanosTest" ("ROW_ID" VARCHAR PRIMARY KEY, "f"."q"  TIMESTAMP)

