---
layout: blog
title:  "Fedora 装机必备"
date:   2017-08-19 16:40:00
categories: linux
permalink: /fedora-souftwares
author: Kylin Soong
excerpt: Fedora 装机必备
---

## Fedora 26 Installation Scripts

### Chrome

[https://www.google.com/chrome/](https://www.google.com/chrome/)

### GIMP

~~~
# dnf install gimp
~~~

More details about GIMP refer to [https://www.gimp.org/](https://www.gimp.org/)

### xchat

~~~
# dnf install xchat
~~~

### Set up Github Client

[https://help.github.com/articles/connecting-to-github-with-ssh/](https://help.github.com/articles/connecting-to-github-with-ssh/)

### Maven 

~~~
wget http://apache.claz.org/maven/maven-3/3.5.0/binaries/apache-maven-3.5.0-bin.zip

unzip apache-maven-3.5.0-bin.zip

vim .bash_profile
  PATH=$PATH:$HOME/tools/apache-maven-3.5.0/bin
source .bash_profile
~~~

### JDK

[http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)

~~~
tar -xvf jdk-8u144-linux-x64.tar.gz

vim .bash_profile
  PATH=$PATH:/usr/java/jdk1.8.0_144/bin
source .bash_profile

rm /etc/alternatives/java
ln -s /usr/java/jdk1.8.0_144/bin/java /etc/alternatives/java
~~~

### 中文输入法

Setting -> Region & Language

### Jekyll  

~~~
dnf install ruby
dnf install rubygem-json 

gem update --system

gem install jekyll
~~~

### GitBook

[https://toolchain.gitbook.com/setup.html](https://toolchain.gitbook.com/setup.html)
