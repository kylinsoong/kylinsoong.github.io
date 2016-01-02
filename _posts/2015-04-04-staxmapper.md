---
layout: blog
title:  "JBoss staxmapper"
date:   2015-04-04 17:30:12
categories: jboss
author: Kylin Soong
duoshuoid: ksoong2015040401
excerpt: A thin StAX facade which supports plugability plus some usability enhancements.  
---

* Table of contents
{:toc}

## Warm-up

JBoss staxmapper 是对 JDK StaX API 扩展，对外提供一个 facade 接口 org.jboss.staxmapper.XMLMapper, 通过 facade 接口对 XLM 进行读写。

XMLMapper 定义的方法如下:

~~~
public interface XMLMapper {
    void registerRootElement(QName name, XMLElementReader<?> reader);
    void unregisterRootElement(QName name);
    void registerRootAttribute(QName name, XMLAttributeReader<?> reader);
    void unregisterRootAttribute(QName name);
    void parseDocument(Object rootObject, XMLStreamReader reader) throws XMLStreamException;
    void deparseDocument(XMLElementWriter<?> writer, Object rootObject, XMLStreamWriter streamWriter) throws XMLStreamException;
}
~~~

'parseDocument()' 和 'deparseDocument()' 分别用于 XML 读写，调运 'parseDocument()' 之前必须首先调运相关的注册方法，如 'registerRootElement()'，'parseDocument()' 中的 rootObject 用于保存解析 XML 的结果。

XMLMapper 读 XML 分三个步骤:

~~~
// 1. Factory 类创建 XMLMapper 实例
XMLMapper mapper = XMLMapper.Factory.create();

// 2. 注册相关 reader
mapper.registerRootElement(rootElement, rootParser);

// 3. 调运 parseDocument() 方法
mapper.parseDocument(results, reader);
~~~ 

XMLMapper 写 XML 分两个步骤:

~~~
// 1. Factory 类创建 XMLMapper 实例
XMLMapper mapper = XMLMapper.Factory.create();

// 2. 调运 deparseDocument() 方法
mapper.deparseDocument(writer, object, streamWriter);
~~~

> 详细关于 Facade Design Pattern 参照 [Wikipedia](http://en.wikipedia.org/wiki/Facade_pattern)

接下来我们详细介绍 JBoss staxmapper，内容包括:

* JDK StaX API
* JBoss staxmapper API
* JBoss staxmapper 示例

## JDK StaX API

Before learning the `JBoss staxmapper` we first need to learn the StAX API.

Streaming API for XML, called StaX, is an API for reading and writing XML Documents. StaX is a Pull-Parsing model. Application can take the control over parsing the XML documents by pulling (taking) the events from the parser. 

> [Wikipedia article](http://en.wikipedia.org/wiki/StAX) explain why StAX are better in performance than DOM and SAX.

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

#### Example.1 XMLStreamReader

The example will illustrate use the Cursor API read XML file, run StaxXMLStreamReader will read xml content and output to console

[StaxXMLStreamReader](https://github.com/kylinsoong/wildfly-samples/blob/master/staxmapper/quickstart/src/main/java/org/jboss/staxmapper/quickstart/StaxXMLStreamReader.java)

#### Example.2 XMLStreamWriter

The example will illustrate use the Cursor API write XML file, run StaxXMLStreamWriter will generate a xml and output to console

[StaxXMLStreamWriter](https://github.com/kylinsoong/wildfly-samples/blob/master/staxmapper/quickstart/src/main/java/org/jboss/staxmapper/quickstart/StaxXMLStreamReader.java)

#### Example.3 XMLEventReader

The example will illustrate use The Event Iterator API read XML file, run StaxXMLEventReader will read xml content and output to console

[StaxXMLEventReader](https://github.com/kylinsoong/wildfly-samples/blob/master/staxmapper/quickstart/src/main/java/org/jboss/staxmapper/quickstart/StaxXMLEventReader.java)

#### Example.4 XMLEventWriter

The example will illustrate use The Event Iterator API write XML file, run StaxXMLEventWriter will generate a XML and output to console

[StaxXMLEventWriter](https://github.com/kylinsoong/wildfly-samples/blob/master/staxmapper/quickstart/src/main/java/org/jboss/staxmapper/quickstart/StaxXMLEventWriter.java)

## JBoss staxmapper API

JBoss staxmapper is a thin StAX facade which supports plugability plus some usability enhancements.

[JBoss staxmapper Source Code](https://github.com/jbossas/staxmapper)

JBoss staxmapper mainly extend the Stax Cursor API, we can separate staxmapper API to 3 categories: 

### Category.1 Stax Cursor API's extention

[org.jboss.staxmapper.XMLExtendedStreamWriter](https://github.com/jbossas/staxmapper/blob/master/src/main/java/org/jboss/staxmapper/XMLExtendedStreamWriter.java) extends `javax.xml.stream.XMLStreamWriter` which the extention mainly focus on format the the XML for configuration files.

[org.jboss.staxmapper.FormattingXMLStreamWriter](https://github.com/jbossas/staxmapper/blob/master/src/main/java/org/jboss/staxmapper/FormattingXMLStreamWriter.java) implemwnts the [org.jboss.staxmapper.XMLExtendedStreamWriter](https://github.com/jbossas/staxmapper/blob/master/src/main/java/org/jboss/staxmapper/XMLExtendedStreamWriter.java).

[org.jboss.staxmapper.XMLExtendedStreamReader](https://github.com/jbossas/staxmapper/blob/master/src/main/java/org/jboss/staxmapper/XMLExtendedStreamReader.java) extends `javax.xml.stream.XMLStreamReader` which the extention mainly focus on read nested content using a registered set of root elements.

[org.jboss.staxmapper.XMLExtendedStreamReaderImpl](https://github.com/jbossas/staxmapper/blob/master/src/main/java/org/jboss/staxmapper/XMLExtendedStreamReaderImpl.java) implements the [org.jboss.staxmapper.XMLExtendedStreamReader](https://github.com/jbossas/staxmapper/blob/master/src/main/java/org/jboss/staxmapper/XMLExtendedStreamReader.java).

[org.jboss.staxmapper.FixedXMLStreamReader](https://github.com/jbossas/staxmapper/blob/master/src/main/java/org/jboss/staxmapper/FixedXMLStreamReader.java) implements `javax.xml.stream.XMLStreamReader` which use a delegate to read XML configuration files. 

### Category.2 Customized API

[org.jboss.staxmapper.XMLAttributeReader](https://github.com/jbossas/staxmapper/blob/master/src/main/java/org/jboss/staxmapper/XMLAttributeReader.java) which pulls an object information out of some XML attribute and appends it to a provided object model.

[org.jboss.staxmapper.XMLElementReader](https://github.com/jbossas/staxmapper/blob/master/src/main/java/org/jboss/staxmapper/XMLElementReader.java) which pulls an object out of some XML element and appends it to a provided object model.

[org.jboss.staxmapper.XMLElementWriter](https://github.com/jbossas/staxmapper/blob/master/src/main/java/org/jboss/staxmapper/XMLElementWriter.java) which writers for XML elements.

### Category.3 Thin StAX facade API

[org.jboss.staxmapper.XMLMapper](https://github.com/jbossas/staxmapper/blob/master/src/main/java/org/jboss/staxmapper/XMLMapper.java) can be though as a facade for JBoss staxmapper, which allows the creation of extensible streaming XML parsers.

[org.jboss.staxmapper.XMLMapperImpl](https://github.com/jbossas/staxmapper/blob/master/src/main/java/org/jboss/staxmapper/XMLMapperImpl.java) implements [org.jboss.staxmapper.XMLMapper](https://github.com/jbossas/staxmapper/blob/master/src/main/java/org/jboss/staxmapper/XMLMapper.java).

### Examples

Assuming we have extract WildFly jca subsystem configuration as

[subsystem-jca.xml](https://github.com/kylinsoong/wildfly-samples/blob/master/staxmapper/quickstart/subsystem-jca.xml)

We have examples demonstrate staxmapper API as below:

#### Example.1

The examplw will illustrates how a reader pulls an object out of some XML element and appends it to a provided object model.

[StaxmapperXMLElementReader](https://github.com/kylinsoong/wildfly-samples/blob/master/staxmapper/quickstart/src/main/java/org/jboss/staxmapper/quickstart/StaxmapperXMLElementReader.java)

#### Example.2

The example will illustrates writer for XML elements.

[StaxmapperXMLElementWriter](https://github.com/kylinsoong/wildfly-samples/blob/master/staxmapper/quickstart/src/main/java/org/jboss/staxmapper/quickstart/StaxmapperXMLElementWriter.java)

## JBoss staxmapper 示例

本示例说明 WildFly 在启动过程中是如何通过 JBoss staxmapper 将配置文件(standalone.xml)的内容解析成 JBoss DMR 对象队列。为了简化示例我们只抽取配置文件的 logging subsystem，只注册 logging subsystem 相关的 reader。

> 详细关于 JBoss DMR 的介绍参照 [http://ksoong.org/jboss-dmr/](http://ksoong.org/jboss/2015/04/02/jboss-dmr/)

通过如下步骤来运行 JBoss staxmapper 示例

### 添加相关的 Maven 依赖

~~~
<dependency>
	<groupId>org.wildfly.core</groupId>
	<artifactId>wildfly-logging</artifactId>
	<version>2.0.0.Alpha5-SNAPSHOT</version>
</dependency>
~~~

> wildfly-logging 依赖 JBoss staxmapper 和 JBoss DMR, 添加此依赖 我们会获取所有依赖 jars.

### 抽取 logging subsystem

从 WildFLy 配置文件(standalone.xml) 中抽取 logging subsystem 配置，保存于独立的文件中:

~~~
<subsystem xmlns="urn:jboss:domain:logging:3.0">
	<console-handler name="CONSOLE">
		<level name="INFO"/>
		<formatter>
			<named-formatter name="COLOR-PATTERN"/>
		</formatter>
	</console-handler>
	<periodic-rotating-file-handler name="FILE" autoflush="true">
		<formatter>
			<named-formatter name="PATTERN"/>
		</formatter>
		<file relative-to="jboss.server.log.dir" path="server.log"/>
		<suffix value=".yyyy-MM-dd"/>
		<append value="true"/>
	</periodic-rotating-file-handler>
	<logger category="com.arjuna">
		<level name="WARN"/>
	</logger>
	<logger category="org.apache.tomcat.util.modeler">
		<level name="WARN"/>
	</logger>
	<logger category="org.jboss.as.config">
		<level name="DEBUG"/>
	</logger>
	<logger category="sun.rmi">
		<level name="WARN"/>
	</logger>
	<root-logger>
		<level name="INFO"/>
		<handlers>
			<handler name="CONSOLE"/>
			<handler name="FILE"/>
		</handlers>
	</root-logger>
	<formatter name="PATTERN">
		<pattern-formatter pattern="%d{yyyy-MM-dd HH:mm:ss,SSS} %-5p [%c] (%t) %s%e%n"/>
	</formatter>
	<formatter name="COLOR-PATTERN">
		<pattern-formatter pattern="%K{level}%d{HH:mm:ss,SSS} %-5p [%c] (%t) %s%e%n"/>
	</formatter>
</subsystem>
~~~

### 使用 JBoss staxmapper 解析 logging subsystem 配置

由于 LoggingSubsystemParser_3_0 没有提供 public 构造方法，我们创建 LoggingSubsystemParserWrapper 继承 LoggingSubsystemParser_3_0，如下代码所示:

~~~
package org.jboss.as.logging;

public class LoggingSubsystemParserWrapper extends LoggingSubsystemParser_3_0{
}
~~~

运行如下代码 Conosle 口输出解析完的 Jason 对象:

~~~
QName rootElement = new QName("urn:jboss:domain:logging:3.0", "subsystem");
LoggingSubsystemParserWrapper rootParser = new LoggingSubsystemParserWrapper();
final XMLMapper mapper = XMLMapper.Factory.create();
mapper.registerRootElement(rootElement, rootParser);
		
final List<ModelNode> updates = new ArrayList<ModelNode>();
final FileInputStream fis = new FileInputStream("subsystem-logging.xml");
BufferedInputStream input = new BufferedInputStream(fis);
XMLStreamReader streamReader = XMLInputFactory.newInstance().createXMLStreamReader(input);
mapper.parseDocument(updates, streamReader);
streamReader.close();
input.close();
fis.close();
        
for(ModelNode model : updates) {
   System.out.println(model.toJSONString(true));
}
~~~

如上代码：

* 实例化 QName 时 namespaceURI 与本示例开头 LoggingSubsystem 的 namespace 一致，都为`urn:jboss:domain:logging:3.0` 
* XMLMapper 时通过工厂类创建 `XMLMapper.Factory.create()`
* parseDocument 调运时传入的 Object 为 List<ModelNode>，LoggingSubsystemParser_3_0 在解析过程中将 XML 属性，元素转化成 ModelNode，然后添加到 List<ModelNode>
* 输出 JBoss DMR 结果可以直接转化为 JSON 对象 `model.toJSONString(true)`

Console 口输出如下，它与 Logging Subsystem 的配置对应:

~~~
{"operation" : "add", "address" : [{ "subsystem" : "logging" }]}
{"operation" : "add", "address" : [{ "subsystem" : "logging" },{ "pattern-formatter" : "PATTERN" }], "pattern" : "%d{yyyy-MM-dd HH:mm:ss,SSS} %-5p [%c] (%t) %s%e%n"}
{"operation" : "add", "address" : [{ "subsystem" : "logging" },{ "pattern-formatter" : "COLOR-PATTERN" }], "pattern" : "%K{level}%d{HH:mm:ss,SSS} %-5p [%c] (%t) %s%e%n"}
{"operation" : "add", "address" : [{ "subsystem" : "logging" },{ "console-handler" : "CONSOLE" }], "level" : "INFO", "named-formatter" : "COLOR-PATTERN"}
{"operation" : "add", "address" : [{ "subsystem" : "logging" },{ "periodic-rotating-file-handler" : "FILE" }], "autoflush" : true, "named-formatter" : "PATTERN", "file" : {"relative-to" : "jboss.server.log.dir", "path" : "server.log"}, "suffix" : ".yyyy-MM-dd", "append" : true}
{"operation" : "add", "address" : [{ "subsystem" : "logging" },{ "logger" : "com.arjuna" }], "level" : "WARN"}
{"operation" : "add", "address" : [{ "subsystem" : "logging" },{ "logger" : "org.apache.tomcat.util.modeler" }], "level" : "WARN"}
{"operation" : "add", "address" : [{ "subsystem" : "logging" },{ "logger" : "org.jboss.as.config" }], "level" : "DEBUG"}
{"operation" : "add", "address" : [{ "subsystem" : "logging" },{ "logger" : "sun.rmi" }], "level" : "WARN"}
{"operation" : "add", "address" : [{ "subsystem" : "logging" },{ "root-logger" : "ROOT" }], "level" : "INFO", "handlers" : ["CONSOLE","FILE"]}
~~~
