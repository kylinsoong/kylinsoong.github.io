---
layout: blog
title:  "Picketbox authentication in j2se"
date:   2015-09-15 22:20:12
categories: security
permalink: /picketbox-j2se
author: Kylin Soong
duoshuoid: ksoong2015091502
---

Purpose of this article is use a example show how to use picketbox in j2se environment.

The steps of using Picketbox in j2se including:

* Prepare authentication file
* Define credentials/principals
* Run in j2se

At the ending of this article there will be a example show Picketbox authentication in j2se with UsersRolesLoginModule.

## Prepare authentication file

Prepare authentication file is a xml file, it can define authentication login-module, flag, etc, below is a example:

~~~
<?xml version='1.0'?> 
 
<policy xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
         xsi:schemaLocation="urn:jboss:security-config:5.0"
         xmlns="urn:jboss:security-config:5.0"
         xmlns:jbxb="urn:jboss:security-config:5.0">
   <application-policy name = "Sample"> 
       <authentication>
          <login-module code = "org.jboss.security.auth.spi.UsersRolesLoginModule" flag = "required">  
          </login-module> 
       </authentication> 
    </application-policy>  
</policy> 
~~~

> NOTE: application-policy's name reference to securityDomain.

## Define credentials/principals

Security credentials/principals can be user/groups in properties files/LDAP Server/RDBMS, which depend on login-module definition in autentication file, use UsersRolesLoginModule as example,users.properties and roles.properties should be added under class path.

Sample roles.properties:

~~~
kylin=user
~~~

Sample users.properties

~~~
kylin=password
~~~

## Run in j2se

Run in j2se sample code as below, it has 5 key steps:

~~~
//1. establish the JAAS Configuration with picketbox authentication xml file
SecurityFactory.prepare(); 

//2. load picketbox authentication xml file
PicketBoxConfiguration config = new PicketBoxConfiguration();
config.load(SampleMain.class.getClassLoader().getResourceAsStream("picketbox/authentication.conf"));

//3. get AuthenticationManager
AuthenticationManager authManager = SecurityFactory.getAuthenticationManager(securityDomain);

//4. execute authentication
authManager.isValid(userPrincipal, credString, subject);

//5. release resource
SecurityFactory.release();
~~~

## Example

This example show run picketbox in J2se environment.

## Get Code and Build

~~~
$ git clone git@github.com:kylinsoong/security-examples.git
$ cd security-examples/picketbox-j2se/
$ mvn clean install dependency:copy-dependencies
~~~

## Run

~~~
$ java -cp target/dependency/*:target/picketbox-j2se.jar javax.security.examples.SampleMain
Username:kylin
Password:password
Authentication succeeded!
~~~

NOTE: Only `kylin` as username, `password` as password authentication can success.
