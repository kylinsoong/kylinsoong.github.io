---
layout: blog
title:  "Web Service StateService 示例"
date:   2014-09-10 16:00:00
categories: javaee
permalink: /jaxws-stateservice
author: Kylin Soong
duoshuoid: ksoong2014091001
---

Web Service StateService 提供获取所有 State 信息和根据 stateCode 获取 State 信息两个接口，本文演示如何部署 StateService 到 JBoss EAP 6，并通过 soapUI 调运 StateService。

## StateService 部署

* 本示例代码: [https://github.com/kylinsoong/jaxws/tree/master/stateService](https://github.com/kylinsoong/jaxws/tree/master/stateService)

* 使用 Maven 命令

~~~
mvn clean install
~~~

可以生成 `StateService.jar`,我们将 `StateService.jar` 部署到 JBoss EAP 6，JBoss 日志出现如下信息说明部署成功:

~~~
18:16:07,231 INFO  [org.jboss.ws.cxf.metadata] (MSC service thread 1-3) JBWS024061: Adding service endpoint metadata: id=StateServiceImpl
 address=http://localhost:8080/StateService/stateService/StateServiceImpl
 implementor=org.teiid.stateservice.StateServiceImpl
 serviceName={http://www.teiid.org/stateService/}stateService
 portName={http://www.teiid.org/stateService/}StateServiceImplPort
 annotationWsdlLocation=null
 wsdlLocationOverride=null
 mtomEnabled=false
~~~

* WSDL 链接: [http://localhost:8080/StateService/stateService/StateServiceImpl?WSDL](http://localhost:8080/StateService/stateService/StateServiceImpl?WSDL)

## 使用 Java 代码调运 StateService

运行 [StateServiceClient](https://github.com/kylinsoong/jaxws/blob/master/stateService/src/main/java/org/teiid/stateservice/client/StateServiceClient.java) 会依次调运 getAllStateInfo() 和 getStateInfo() 方法。

同样 [StateServiceClient](https://github.com/kylinsoong/jaxws/blob/master/stateService/src/main/java/org/teiid/stateservice/client/StateServiceClient.java) 也演示了不同的 CXF 客户端的编写，包括：

* CXF Proxy API 客户端

~~~
final Service service = Service.create(wsdlURL, serviceName);
StateService client = service.getPort(portName, StateService.class);
~~~

* CXF Dispatch JAXB 客户端

~~~
final Service service = Service.create(wsdlURL, serviceName);
JAXBContext ctx = JAXBContext.newInstance("org.teiid.stateservice.jaxb", StateServiceClient.class.getClassLoader());
Dispatch<Object> dispatch = service.createDispatch(portName, ctx, Mode.PAYLOAD);
Object response = dispatch.invoke(new ObjectFactory().createGetAllStateInfo());
~~~

* CXF Dispatch SOAP 请求客户端

~~~
final Service service = Service.create(wsdlURL, serviceName);
Dispatch<SOAPMessage> dispatch = service.createDispatch(portName, SOAPMessage.class, Mode.MESSAGE);
String getAll = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:stat=\"http://www.teiid.org/stateService/\"><soapenv:Header/><soapenv:Body><stat:GetAllStateInfo></stat:GetAllStateInfo></soapenv:Body></soapenv:Envelope>";
SOAPMessage response = dispatch.invoke(getRequest(getAll));
~~~

* CXF Dispatch DOMSource 客户端

~~~
final Service service = Service.create(wsdlURL, serviceName);
Dispatch<Source> dispatch = service.createDispatch(portName, Source.class, Mode.PAYLOAD);
DocumentBuilder db = DocumentBuilderFactory.newInstance().newDocumentBuilder();
Document requestDoc = db.newDocument();
Element rootElement = requestDoc.createElementNS("http://www.teiid.org/stateService/", "GetAllStateInfo");
requestDoc.appendChild(rootElement);
DOMSource request = new DOMSource(requestDoc);
Source response = dispatch.invoke(request);
~~~

* CXF Dispatch StAXSource 客户端

~~~
service = Service.create(serviceName);
String bindingId = "http://schemas.xmlsoap.org/wsdl/soap/http";
String endpointAddress = "http://localhost:8080/StateService/stateService/StateServiceImpl?WSDL";
service.addPort(portName, bindingId, endpointAddress);
Dispatch<StAXSource> dispatch = service.createDispatch(portName, StAXSource.class, Mode.PAYLOAD);
		
String xmlRequest = "<GetAllStateInfo xmlns=\"http://www.teiid.org/stateService/\"/>";
XMLInputFactory factory = XMLInputFactory.newInstance();
StAXSource source = new StAXSource(factory.createXMLStreamReader(new ByteArrayInputStream(xmlRequest.getBytes())));
StAXSource returnValue = dispatch.invoke(source);
~~~

## 使用 soapUI 调运 StateService

* 启动 [soapUI](http://www.soapui.org/)，选择 `New Project` 创建工程 **StateServiceClient**，指定 WSDL 为 [http://localhost:8080/StateService/stateService/StateServiceImpl?WSDL](http://localhost:8080/StateService/stateService/StateServiceImpl?WSDL)

![soapUI create project]({{ site.baseurl }}/assets/blog/soapui-create.png)

* 选择 GetAllStateInfo -> Request 1，发送 SOAP 请求如下图所示

![soapUI getall]({{ site.baseurl }}/assets/blog/soapui-send1.png)

所有 State 信息被返回

* 选择 GetStateInfo -> Request 1，发送 SOAP 请求如下图所示

![soapUI getone]({{ site.baseurl }}/assets/blog/soapui-send2.png)

返回结果 SOAP 消息如下所示:

~~~
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
   <soap:Body>
      <ns2:GetStateInfoResponse xmlns:ns2="http://www.teiid.org/stateService/">
         <StateInfo>
            <Name>California</Name>
            <Abbreviation>CA</Abbreviation>
            <Capital>Sacramento</Capital>
            <YearOfStatehood>1850</YearOfStatehood>
         </StateInfo>
      </ns2:GetStateInfoResponse>
   </soap:Body>
</soap:Envelope>
~~~
