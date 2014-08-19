---
layout: blog
title:  "Teiid Language API"
date:   2014-08-19 17:20:12
categories: teiid
permalink: /teiid-language-api
author: Kylin Soong
duoshuoid: ksoong20140819
---

This document introduce the Teiid language API with UML diagram and Junit Test code.

### org.teiid.language.Call

![Teiid Language API Call]({{ site.baseurl }}/assets/blog/Call.gif)

* The `Call` represents a procedural execution (such as a stored procedure).
* The `LanguageObject` is root interface for all language object interfaces.
* The `MetadataReference` used to mark language objects as having a reference to a MetadataID. 
* The `Command` represents a command in the language objects. A command is an instruction of something to execute sent to the connector. Typical commands perform SELECT, INSERT, UPDATE, DELETE, etc type operations.

### org.teiid.language.Argument

![Teiid Language API Argument]({{ site.baseurl }}/assets/blog/Argument.gif)

A Junit code snippets for using above API:

~~~
	@Test
	public void testCall() {
		
		Literal literal = new Literal("marketdata.csv", TypeFacility.RUNTIME_TYPES.STRING);
		Argument argument = new Argument(Direction.IN, literal, TypeFacility.RUNTIME_TYPES.STRING, null);
		Call call = LanguageFactory.INSTANCE.createCall("getTextFiles", Arrays.asList(argument), null);
		assertEquals("getTextFiles", call.getProcedureName());
		assertNotNull(call.getArguments());
	}
~~~
