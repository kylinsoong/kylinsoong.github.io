---
layout: blog
title:  "WildFly Controller API"
date:   2015-07-04 16:50:12
categories: jboss
author: Kylin Soong
duoshuoid: ksoong2015070401
excerpt: This article contains the description of WildFly Controller API
---

### org.jboss.as.controller.ResourceDefinition

![ResourceDefinition]({{ site.baseurl }}/assets/blog/wildfly-contorller-resourcedefinition.png)

* ResourceDefinition - Provides essential information defining a management resource.
* DelegatingResourceDefinition - A simple internal implementation using Delegate Design Pattern
* ServerDelegatingResourceDefinition - A usage example in WildFly ServerService

### org.jboss.as.controller.persistence.ExtensibleConfigurationPersister

![ExtensibleConfigurationPersister]({{ site.baseurl }}/assets/blog/wildfly-contorller-persistenceconfig.png)

* ConfigurationPersister - The configuration persister for a model.
* SubsystemXmlWriterRegistry - Registry for 'XMLElementWriter' that can marshal the configuration for a subsystem.
* ExtensibleConfigurationPersister - Combines 'ConfigurationPersister' and 'SubsystemXmlWriterRegistry'
* AbstractConfigurationPersister - Abstract superclass for 'ExtensibleConfigurationPersister' implementations.
* NullConfigurationPersister - A configuration persister which does not store configuration changes.
* XmlConfigurationPersister - A configuration persister which uses an XML file for backing storage.
* BackupXmlConfigurationPersister - An XML configuration persister which backs up the old file before overwriting it.

### org.jboss.as.controller.registry.ManagementResourceRegistration

![ManagementResourceRegistration]({{ site.baseurl }}/assets/blog/wildfly-contorller-resourceregistration.png)

* ImmutableManagementResourceRegistration - Read-only view of a 'ManagementResourceRegistration'
* ManagementResourceRegistration - A registration for a management resource which consists of a resource description plus registered operation handlers.
* ConcreteResourceRegistration/AbstractResourceRegistration - internal implementation for root registration

### org.jboss.as.controller.ModelController

![ModelController]({{ site.baseurl }}/assets/blog/wildfly-contorller-modelcontroller.png)

* ModelController - Controls reads of and modifications to a management model.
* ModelControllerImpl - Default 'ModelController' implementation.
