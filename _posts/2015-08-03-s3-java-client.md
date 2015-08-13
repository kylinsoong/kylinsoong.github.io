---
layout: blog
title:  "AWS S3 Java Client Example"
date:   2015-08-03 18:00:00
categories: data
permalink: /aws-s3-java
author: Kylin Soong
duoshuoid: ksoong2015080301
---

This article includes steps to run AWS S3 Java Client.

## Set up credentials

As [http://docs.aws.amazon.com/AWSSdkDocsJava/latest/DeveloperGuide/credentials.html](http://docs.aws.amazon.com/AWSSdkDocsJava/latest/DeveloperGuide/credentials.html), there are 4 ways for configuring credentials, we will introduce create a `credentials` file under ' ~/.aws/'.

* Create Access Key 

Login [https://console.aws.amazon.com/iam/home?#security_credential](https://console.aws.amazon.com/iam/home?#security_credential), Click 'Access Keys(...)', Click 'Generate New Access Key' button, these will generate a aws_access_key_id and aws_secret_access_key.

* Put it to credentials file

Create a credentials file under ' ~/.aws/'

~~~
[default]
aws_access_key_id=YOUR_ACCESS_KEY_ID
aws_secret_access_key=YOUR_SECRET_ACCESS_KEY
~~~

## Run S3Client

[S3Client.java](https://raw.githubusercontent.com/kylinsoong/aws-java-sample/master/src/main/java/com/amazonaws/samples/S3Client.java)
 
