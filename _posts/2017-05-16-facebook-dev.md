---
layout: blog
title:  "Facebook Integration with Enterprise Micro Service Solution"
date:   2017-05-16 21:00:00
categories: data
permalink: /facebook-dev
author: Kylin Soong
excerpt: How to register an Application with Facebook and become a Facebook developer, integrate facebook with Spring boot, WildFly Swarm, Apache Camel Facebook component.  
---

* Table of contents
{:toc}

## Registering an Application with Facebook

This section walks you through the steps of registering an application to integrate with Facebook.

### Become a Facebook developer

If you do not already have an account with Facebook, go to [https://www.facebook.com/](https://www.facebook.com/) and register one.

Then go to [https://developers.facebook.com/](https://developers.facebook.com/), and click Register Now button at the top of the page. Facebook walks you through a series of dialogs, complete the Accept the terms,  Verify your account, etc.

### Register a new application

From [https://developers.facebook.com/](https://developers.facebook.com/)  click on "My Apps" at the top of the page to go to the application dashboard. The dashboard shows a list of applications that the developer has created. You haven’t created any applications yet, so the list is empty.

Click the `Create a New App` button near the top,

![Create a App]({{ site.baseurl }}/assets/blog/data/fb-create-new-app.png)

A dialog prompts you to name your application and contact mail,

![Create App ID]({{ site.baseurl }}/assets/blog/data/fb-create-new-appid.png)

Click `Create App ID` button to continue, a new App ID id created, navigate to your application’s application settings page,

![App ID Secret]({{ site.baseurl }}/assets/blog/data/fb-app-id-secret.png)

From the application settings page, you can configure various details about your application. The main thing to note from the application settings page is the **App ID** and **App Secret** near the top. These values are your application’s credentials to Facebook. You need these credentials to do almost anything with Facebook, including going through the OAuth authorization flow in the following sections.

## Facebook Integration using Spring boot

* Clone Spring get start code

~~~
git clone https://github.com/spring-guides/gs-accessing-facebook.git
cd gs-accessing-facebook/complete/
~~~

* Edit `src/main/resources/application.properties`, make sure the **App ID** and **App Secret** as created above

~~~
spring.social.facebook.appId=862558810566543
spring.social.facebook.appSecret=33b17e044ee6a4fa383f46ec6e28ea1d
~~~

* Build Application

~~~
mvn clean install
~~~

* Run Application

~~~
java -jar target/gs-accessing-facebook-0.1.0.jar
~~~

* Test Application

Once the application starts up, point your web browser to [http://localhost:8080](http://localhost:8080). No connection is established yet, so this screen prompts you to connect with Facebook:

![Test Connect]({{ site.baseurl }}/assets/blog/data/fb-test-connect.png)

When you click the **Connect to Facebook** button, the browser is redirected to Facebook for authorization:

![Test Connect AS]({{ site.baseurl }}/assets/blog/data/fb-test-connect-as.png)

Once permission is granted, Facebook redirects the browser back to the application. A connection is created and stored in the connection repository. You should see this page indicating that a connection was successful:

![Test Connect success]({{ site.baseurl }}/assets/blog/data/fb-test-connect-success.png)


## Facebook Integration using WildFly Swarm


## Facebook Integration using Apache Camel

