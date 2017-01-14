---
layout: blog
title:  "Install jBPM from jbpm-installer"
date:   2017-01-14 20:00:12
categories: jbpm
permalink: /jbpm-plugin-install
author: Kylin Soong
duoshuoid: ksoong2017011403
excerpt: Install jBPM Eclipse Plugin to Eclipse
---

* Table of contents
{:toc}

## Install the Drools and jBPM Eclipse plugin

### Install the Drools and jBPM Eclipse plugin via update site

* To install from this site, start up Eclipse 4.5 (Mars), then do: 

**Help > Install New Software... >**

* Copy this site's URL into Eclipse, and hit Enter.

[http://downloads.jboss.org/jbpm/release/6.5.0.Final/updatesite/](http://downloads.jboss.org/jbpm/release/6.5.0.Final/updatesite/) 

* When the site loads, select the features to install, or click the Select All button. 	

* To properly resolve all dependencies, check 

* Click Next, agree to the license terms, and install.

### Install the Drools and jBPM Eclipse plugin via zip archive

~~~
wget http://download.eclipse.org/technology/epp/downloads/release/neon/R/eclipse-java-neon-R-linux-gtk-x86_64.tar.gz
tar -xvf eclipse-java-neon-R-linux-gtk-x86_64.tar.gz

wget https://download.jboss.org/jbpm/release/6.5.0.Final/jbpm-6.5.0.Final-installer-full.zip
unzip jbpm-6.5.0.Final-installer-full.zip

unzip jbpm-installer/lib/org.drools.updatesite-6.5.0.Final.zip -d eclipse/droolsjbpm-update-site
cp -r eclipse/droolsjbpm-update-site/features/ eclipse/features
cp -r eclipse/droolsjbpm-update-site/plugins/ eclipse/plugins
~~~

## Install Eclipse BPMN2 Modeler plugin

* All version eclpse  https://www.eclipse.org/bpmn2-modeler/downloads.php

* Eclipse Mar 4.5 update site: http://download.eclipse.org/bpmn2-modeler/updates/mars/1.2.4

* Eclipse Neon 4.6 update site: http://download.eclipse.org/bpmn2-modeler/updates/neon/1.3.0

