---
layout: blog
title:  "RESTEasy Exception Handling with ExceptionMapper"
date:   2015-09-15 21:30:12
categories: jboss
author: Kylin Soong
duoshuoid: ksoong2015091501
excerpt: RESTEasy Exception Handling with ExceptionMapper, Different behavior between HttpServletDispatcher and FilterDispatcher
---

## What's this


JAX-RS has defined a ExceptionMapper(javax.ws.rs.ext.ExceptionMapper), which contract for a provider that maps Java exceptions to a `javax.ws.rs.core.Response`. Purpose of the article is to show how to handle exception in RESTEasy.

## How to do

As [document](https://developer.jboss.org/wiki/RESTEasyExceptionHandlingWithExceptionMapper), the following 2 steps are necessary for applying ExceptionMapper in RESTEasy:

* Implements ExceptionMapper
* Register ExceptionMapper in the web.xml

### Implements ExceptionMapper

The following is a example of ExceptionMapper implements.

~~~
package org.jboss.resteasy.examples;

import java.io.PrintWriter;
import java.io.StringWriter;

import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.ext.ExceptionMapper;
import javax.ws.rs.ext.Provider;

import org.jboss.resteasy.spi.InternalServerErrorException;
import org.jboss.resteasy.spi.NotFoundException;

@Provider
public class DefaultExceptionHandler implements ExceptionMapper<Exception> {

	@Override
	public Response toResponse(Exception e) {
		String status = "ERROR";
        if(e instanceof NotFoundException){
                status = "404";
        } else if(e instanceof InternalServerErrorException){
                status = "500";
        }

        String message = e.getMessage();

        StringWriter sw = new StringWriter();
        PrintWriter pw = new PrintWriter(sw);
        e.printStackTrace(pw);
        String details = sw.toString();

        StringBuilder response = new StringBuilder("<error>");
		response.append("<code>" + status + "</code>");
		response.append("<message>" + message + "</message>");
		response.append("<details>" + details + "</details>");
		response.append("</error>");
		return Response.serverError().entity(response.toString()).type(MediaType.APPLICATION_XML).build();
	}

}
~~~

### Register ExceptionMapper in the web.xml

Register the DefaultExceptionHandler in your web.xml

~~~
  <context-param>
        <param-name>resteasy.providers</param-name>
        <param-value>org.jboss.samples.rs.webservices.DefaultExceptionHandler</param-value>
  </context-param>
~~~

## Run

### Requirements

* Clone Build Test Project（Maven 3.x and Java 7）

~~~
$ git clone git@github.com:kylinsoong/jaxrs.git
$ cd jaxrs/exceptionMapper/
$ mvn clean install
~~~

Once build completed, `a.war` and `b.war` will be generated under 'HttpServletDispatcher/target' and 'FilterDispatcher/target' correspondingly.

* JBoss EAP 6.x

~~~
$ ./bin/standalone.sh
~~~

### Deploy and Run a.war

a.war use ServletDispatcher in web.xml to supply RESTEasy support, it looks as below:

~~~
  <servlet>
    <servlet-name>Resteasy</servlet-name>
    <servlet-class>org.jboss.resteasy.plugins.server.servlet.HttpServletDispatcher</servlet-class>
  </servlet>
  <servlet-mapping>
    <servlet-name>Resteasy</servlet-name>
    <url-pattern>/*</url-pattern>
  </servlet-mapping>
~~~

Deploy a.war to JBoss EAP 6.x, once deploy completed, test via http://localhost:8080/a/MyRESTApplication/customerList, all customer will be listed:

![war a list customer]({{ site.baseurl }}/assets/blog/rest-exception-mapper-a1.png)

If test with a not exist api like http://localhost:8080/a/MyRESTApplication/customerList-noexist, 404 response return:

![war a 404]({{ site.baseurl }}/assets/blog/rest-exception-mapper-a2.png)

### Deploy and Run b.war

b.war use FilterDispatcher in web.xml to supply RESTEasy support, it looks as below:

~~~
    <filter>
        <filter-name>Resteasy</filter-name>
        <filter-class>org.jboss.resteasy.plugins.server.servlet.FilterDispatcher</filter-class>
    </filter>
    <filter-mapping>
        <filter-name>Resteasy</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>
~~~

Deploy b.war to JBoss EAP 6.x, once deploy completed, test via http://localhost:8080/b/MyRESTApplication/customerList, all customer will be listed:

![war b list customer]({{ site.baseurl }}/assets/blog/rest-exception-mapper-b1.png)

If test with a not exist api like http://localhost:8080/b/MyRESTApplication/customerList-noexist, 404 page return:

![war b 404]({{ site.baseurl }}/assets/blog/rest-exception-mapper-b2.png)

## Why behave differently

From above Run section, we can see FilterDispatcher and ServletDispatcher behave differently, If use FilterDispatcher, Http Error Code can not be mapped. In this section we will find the the reson for why behave differently.

