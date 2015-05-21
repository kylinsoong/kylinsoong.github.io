---
layout: blog
title:  "Logging in Java"
date:   2014-11-27 16:55:00
categories: java
permalink: /java-logging
author: Kylin Soong
duoshuoid: ksoong2014112701
---

This article first will talk some basic concepts in Java Util Logging, then give 2 examples: 

* **Setting the Logging Configuration with configuration file**
* **Setting the Logging Configuration Programmatically** 

## Concepts

Java contains the Java Logging API. This logging API allows you to configure which message types are written. Individual classes can use this logger to write messages to the configured log files.

The java.util.logging package provides the logging capabilities via the Logger class.  To create a logger in your Java code, you can use the following snippet:

~~~
import java.util.logging.Logger;

private final static Logger logger = Logger.getLogger(MyLoggerTestClass.class.getName()); 
~~~

### Logger Level

The log levels define the severity of a message. The `java.util.logging.Level` class is used to define which messages should be written to the log. The levels in descending order are:

* SEVERE (highest value)
* WARNING
* INFO
* CONFIG
* FINE
* FINER
* FINEST  (lowest value) 

### Handler

Each logger can have access to several handlers. The handler receives the log message from the logger and exports it to a certain target. By default, java util logging have 3 handlers:

* ConsoleHandler: Write the log message to console
* FileHandler: Writes the log message to file 
* SocketHandler: Writes the log message to socket

### Formatter

Each handler's output can be configured with a formatter, by default, java util logging have 2 formatter:

* SimpleFormatter: Generate all messages as text 
* XMLFormatter: Generates XML output for the log messages 

Below is is a sample to build a customized formatter:

~~~
class MyFormatter extends Formatter {
	
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm SSS");

	public String format(LogRecord record) {
		StringBuffer sb = new StringBuffer();
		sb.append(format.format(new Date(record.getMillis())) + " ");
		sb.append(getLevelString(record.getLevel()) + " ");
		sb.append("[" + record.getLoggerName() + "]  (");
		sb.append(Thread.currentThread().getName() + ") ");
		sb.append(record.getMessage() + "\n");
		return sb.toString();
	}

	private String getLevelString(Level level) {
		String name = level.toString();
		int size = name.length();
		for(int i = size; i < 7 ; i ++){
			name += " ";
		}
		return name;
	}
}
~~~

## Setting the Logging Configuration with configuration file

Setting the Logging Configuration need a `logging properties`, and including it via VM argument:

~~~
-Djava.util.logging.config.file="logging.properties" 
~~~

> Note that there is a sample properties under jre/lib

Base on jre/lib/logging.properties, change the following 2 lines:

~~~
.level= FINEST
java.util.logging.ConsoleHandler.formatter = MyFormatter
~~~

## Setting the Logging Configuration Programmatically

Below is a sample for setting the Logging Configuration Programmatically:

~~~
Logger rootLogger = Logger.getLogger("");
for(Handler handler : rootLogger.getHandlers()){
	// use customized MyFormatter, change rootLogger's level from INFO to SEVERE
	handler.setFormatter(new MyFormatter());
	handler.setLevel(Level.SEVERE);
}

Logger logger = Logger.getLogger("com.mylogger");
logger.setLevel(Level.FINEST);
ConsoleHandler handler = new ConsoleHandler();
handler.setFormatter(new MyFormatter());
handler.setLevel(Level.FINEST);
logger.addHandler(handler);
logger.setUseParentHandlers(false);
~~~

## An example for using above setting

Run below code

~~~
public static void main(String[] args) {
	Logger logger = Logger.getLogger("com.mylogger.x.y");
			
	logger.finest("This is finest test message");
	logger.finer("This is finer test message");
	logger.fine("This is fine test message");
	logger.config("This is config test message");
	logger.info("This is info test message");
	logger.warning("This is warning test message");
	logger.severe("This is severe test message");	
}
~~~

will out put

~~~
2015-05-21 16:39 331 FINEST  [com.mylogger.x.y] (main) This is finest test message
2015-05-21 16:39 332 FINER   [com.mylogger.x.y] (main) This is finer test message
2015-05-21 16:39 332 FINE    [com.mylogger.x.y] (main) This is fine test message
2015-05-21 16:39 332 CONFIG  [com.mylogger.x.y] (main) This is config test message
2015-05-21 16:39 332 INFO    [com.mylogger.x.y] (main) This is info test message
2015-05-21 16:39 333 WARNING [com.mylogger.x.y] (main) This is warning test message
2015-05-21 16:39 333 SEVERE  [com.mylogger.x.y] (main) This is severe test message
~~~

