---
layout: blog
title:  "JBoss staxmapper"
date:   2015-04-04 17:30:12
categories: jboss
author: Kylin Soong
duoshuoid: ksoong2015040401
excerpt: A thin StAX facade which supports plugability plus some usability enhancements.  
---

## Prerequisites

Before knowing the `JBoss staxmapper` we first need know the StAX.

Streaming API for XML, called StaX, is an API for reading and writing XML Documents. StaX is a Pull-Parsing model. Application can take the control over parsing the XML documents by pulling (taking) the events from the parser. 

[Wikipedia article](http://en.wikipedia.org/wiki/StAX) account why StAX are better than DOM and SAX.

The core StaX API falls into two categories and listed as below:

* Cursor API
* Event Iterator API

The Cursor API has two main interfaces:

~~~
javax.xml.stream.XMLStreamReader
javax.xml.stream.XMLStreamWriter
~~~

The Event Iterator API has two main interfaces:

~~~
javax.xml.stream.XMLEventReader
javax.xml.stream.XMLEventWriter
~~~

### Examples

Assuming we have extract WildFly jca subsystem configuration as 

	[subsystem-jca.xml](https://github.com/kylinsoong/wildfly-samples/blob/master/staxmapper/quickstart/subsystem-jca.xml)

We have 4 examples demonstrate StaX Cursor API and Event Iterator API.

**Example.1** Illustrate use The Cursor API read XML file, run StaxXMLStreamReader will read xml content and output to console

	[StaxXMLStreamReader](https://github.com/kylinsoong/wildfly-samples/blob/master/staxmapper/quickstart/src/main/java/org/jboss/staxmapper/quickstart/StaxXMLStreamReader.java)

**Example.2** Illustrate use The Cursor API write XML file, run StaxXMLStreamWriter will generate a xml and output to console

	[StaxXMLStreamWriter](https://github.com/kylinsoong/wildfly-samples/blob/master/staxmapper/quickstart/src/main/java/org/jboss/staxmapper/quickstart/StaxXMLStreamReader.java)

**Example.3** Illustrate use The Event Iterator API read XML file, run StaxXMLEventReader will read xml content and output to console

	[StaxXMLEventReader](https://github.com/kylinsoong/wildfly-samples/blob/master/staxmapper/quickstart/src/main/java/org/jboss/staxmapper/quickstart/StaxXMLEventReader.java)

**Example.4** Illustrate use The Event Iterator API write XML file, run StaxXMLEventWriter will generate a XML and output to console

	[StaxXMLEventWriter](https://github.com/kylinsoong/wildfly-samples/blob/master/staxmapper/quickstart/src/main/java/org/jboss/staxmapper/quickstart/StaxXMLEventWriter.java)

## staxmapper

A thin StAX facade which supports plugability plus some usability enhancements.

[Source Code](https://github.com/jbossas/staxmapper)


