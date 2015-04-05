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

JBoss staxmapper mainly extend the Stax Cursor API, we can separate staxmapper API to 3 categories: 

**Category.1** Stax Cursor API's extention

[org.jboss.staxmapper.XMLExtendedStreamWriter](https://github.com/jbossas/staxmapper/blob/master/src/main/java/org/jboss/staxmapper/XMLExtendedStreamWriter.java) extends `javax.xml.stream.XMLStreamWriter` which the extention mainly focus on format the the XML for configuration files.

[org.jboss.staxmapper.FormattingXMLStreamWriter](https://github.com/jbossas/staxmapper/blob/master/src/main/java/org/jboss/staxmapper/FormattingXMLStreamWriter.java) implemwnts the [org.jboss.staxmapper.XMLExtendedStreamWriter](https://github.com/jbossas/staxmapper/blob/master/src/main/java/org/jboss/staxmapper/XMLExtendedStreamWriter.java).

[org.jboss.staxmapper.XMLExtendedStreamReader](https://github.com/jbossas/staxmapper/blob/master/src/main/java/org/jboss/staxmapper/XMLExtendedStreamReader.java) extends `javax.xml.stream.XMLStreamReader` which the extention mainly focus on read nested content using a registered set of root elements.

[org.jboss.staxmapper.XMLExtendedStreamReaderImpl](https://github.com/jbossas/staxmapper/blob/master/src/main/java/org/jboss/staxmapper/XMLExtendedStreamReaderImpl.java) implements the [org.jboss.staxmapper.XMLExtendedStreamReader](https://github.com/jbossas/staxmapper/blob/master/src/main/java/org/jboss/staxmapper/XMLExtendedStreamReader.java).

[org.jboss.staxmapper.FixedXMLStreamReader](https://github.com/jbossas/staxmapper/blob/master/src/main/java/org/jboss/staxmapper/FixedXMLStreamReader.java) implements `javax.xml.stream.XMLStreamReader` which use a delegate to read XML configuration files. 

**Category.2** Customized API

[org.jboss.staxmapper.XMLAttributeReader](https://github.com/jbossas/staxmapper/blob/master/src/main/java/org/jboss/staxmapper/XMLAttributeReader.java) which pulls an object information out of some XML attribute and appends it to a provided object model.

[org.jboss.staxmapper.XMLElementReader](https://github.com/jbossas/staxmapper/blob/master/src/main/java/org/jboss/staxmapper/XMLElementReader.java) which pulls an object out of some XML element and appends it to a provided object model.

[org.jboss.staxmapper.XMLElementWriter](https://github.com/jbossas/staxmapper/blob/master/src/main/java/org/jboss/staxmapper/XMLElementWriter.java) which writers for XML elements.

**Category.3** Thin StAX facade API

[org.jboss.staxmapper.XMLMapper](https://github.com/jbossas/staxmapper/blob/master/src/main/java/org/jboss/staxmapper/XMLMapper.java) can be though as a facade for JBoss staxmapper, which allows the creation of extensible streaming XML parsers.

[More Facade Design Pattern From Wikipedia](http://en.wikipedia.org/wiki/Facade_pattern)

[org.jboss.staxmapper.XMLMapperImpl](https://github.com/jbossas/staxmapper/blob/master/src/main/java/org/jboss/staxmapper/XMLMapperImpl.java) implements [org.jboss.staxmapper.XMLMapper](https://github.com/jbossas/staxmapper/blob/master/src/main/java/org/jboss/staxmapper/XMLMapper.java).

### Examples

Assuming we have extract WildFly jca subsystem configuration as

[subsystem-jca.xml](https://github.com/kylinsoong/wildfly-samples/blob/master/staxmapper/quickstart/subsystem-jca.xml)

We have examples demonstrate staxmapper API as below:

**Example.1** Illustrates how a reader pulls an object out of some XML element and appends it to a provided object model.

[StaxmapperXMLElementReader](https://github.com/kylinsoong/wildfly-samples/blob/master/staxmapper/quickstart/src/main/java/org/jboss/staxmapper/quickstart/StaxmapperXMLElementReader.java)

**Example.2** Illustrates writer for XML elements.

[StaxmapperXMLElementWriter](https://github.com/kylinsoong/wildfly-samples/blob/master/staxmapper/quickstart/src/main/java/org/jboss/staxmapper/quickstart/StaxmapperXMLElementWriter.java)


