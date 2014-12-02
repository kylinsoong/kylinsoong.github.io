---
layout: blog
title:  "Logging in Java"
date:   2014-11-27 16:55:00
categories: java
permalink: /java-logging
author: Kylin Soong
duoshuoid: ksoong2014112701
---

The content of in article including:

* java util logging
* log4j
* jboss logging

## java util logging

Java contains the Java Logging API. This logging API allows you to configure which message types are written. Individual classes can use this logger to write messages to the configured log files.

The java.util.logging package provides the logging capabilities via the Logger class.  To create a logger in your Java code, you can use the following snippet:

~~~
import java.util.logging.Logger;

private final static Logger logger = Logger.getLogger(MyLoggerTestClass.class.getName()); 
~~~

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

The following is a sample to build a customized formatter:

~~~
class MyFormatter extends Formatter {
	
	SimpleDateFormat format = new SimpleDateFormat("MMM dd,yyyy HH:mm");

	public String format(LogRecord record) {
		StringBuffer sb = new StringBuffer();
		sb.append(format.format(new Date(record.getMillis())) + " ");
		sb.append(record.getLevel() + " ");
		sb.append("[" + record.getLoggerName() + "] ");
		sb.append(record.getMessage());
		return sb.toString();
	}
}
~~~

### An example for using java util logging

Run the following code snippets:

~~~
public static void main(String[] args) {
	Logger logger = Logger.getLogger("java.util.logging.TEST");
	logger.setLevel(Level.FINEST);
	ConsoleHandler handler = new ConsoleHandler();
	handler.setLevel(Level.FINEST);
	handler.setFormatter(new MyFormatter());
	logger.setUseParentHandlers(false);
	logger.addHandler(handler);
			
	logger.finest("This is finest test message");
	logger.finer("This is finer test message");
	logger.fine("This is fine test message");
	logger.config("This is config test message");
	logger.info("This is info test message");
	logger.warning("This is warning test message");
	logger.severe("This is severe test message");	
}
~~~

The following output in console:

~~~
Nov 27,2014 14:34 FINEST [java.util.logging.TEST] This is finest test message
Nov 27,2014 14:34 FINER [java.util.logging.TEST] This is finer test message
Nov 27,2014 14:34 FINE [java.util.logging.TEST] This is fine test message
Nov 27,2014 14:34 CONFIG [java.util.logging.TEST] This is config test message
Nov 27,2014 14:34 INFO [java.util.logging.TEST] This is info test message
Nov 27,2014 14:34 WARNING [java.util.logging.TEST] This is warning test message
Nov 27,2014 14:34 SEVERE [java.util.logging.TEST] This is severe test message
~~~

### Configure java util logging globally 

Configure java util logging globally need a logging properties, and including this properties via VM argument:

~~~
-Djava.util.logging.config.file="logging.properties" 
~~~

> Note that there is a sample properties under jre/lib

Base on jre/lib/logging.properties, we change the following 2 lines:

~~~
.level= FINEST
java.util.logging.ConsoleHandler.formatter = com.teiid.quickstart.log.MyFormatter
~~~

then above example can simplify like:

~~~
public static void main(String[] args) {
	Logger logger = Logger.getLogger("java.util.logging.TEST");
	logger.finest("This is finest test message");
	logger.finer("This is finer test message");
	logger.fine("This is fine test message");
	logger.config("This is config test message");
	logger.info("This is info test message");
	logger.warning("This is warning test message");
	logger.severe("This is severe test message");
}
~~~

The log output are same.

## Log4j

Log4j should be most be used logging framework, a extend of java util logging, add more handlers and formatters.

### API to quick involve Logging

There are some occasion which we need quick configure log4j for debug convenient, below code show this:

~~~
Logger.getLogger("org.apache.hadoop.hbase.client").setLevel(Level.DEBUG);
String pattern = "[%d{ABSOLUTE}] [%t] %5p (%F:%L) - %m%n";
PatternLayout layout = new PatternLayout(pattern);
ConsoleAppender consoleAppender = new ConsoleAppender(layout);
Logger.getRootLogger().addAppender(consoleAppender);  
~~~

## JBoss logging

[https://docs.jboss.org/author/display/AS72/Logging+Configuration](https://docs.jboss.org/author/display/AS72/Logging+Configuration)

[https://github.com/jboss-logging](https://github.com/jboss-logging)
