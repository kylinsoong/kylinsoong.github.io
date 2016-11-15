---
layout: blog
title:  "JBoss Modules 加载服务的实现分析"
date:   2016-11-15 18:40:12
categories: jboss
permalink: /jboss-modules-services
author: Kylin Soong
duoshuoid: ksoong2016111501
---

* Table of contents
{:toc}

## 服务器端程序的一般模式

Java 服务器端程序一般都包括很多不同种类的接口和对应这些接口的实现，通常我们将一个接口(包括抽象类)称为 **Service**, 将接口的实现称为 **Service Provider**， 这样各种各样的 Service 和对应的 Service Provider 的构建成了服务器端的应用.

如图 1 中所示，在编程过程中，API 和对应的实现(Impl) 可以作为一个整体，Server 直接依赖于 API 和其实现，API 的定义是比较简单，但其实现可能非常复杂，通常他依赖于第三方的服务/类库等，这样就导致Server 的代码比较复杂，扩展性差，维护成本高。

![服务器端程序]({{ site.baseurl }}/assets/blog/wildfly/server-side-programming.png)

通过服务器端程序的一般模式如图 2 所示，将 API 和 Impl 分开，Server 只依赖于 API，Server 运行时一般通过 ServiceLoader 加载 Service Provider. 这种模式的好处是降低了 Server 端程序编写的负责程。

## 使用 JBoss Modules 加载 Service Provider

JBoss Modules 是 JBoss/WildFly 底层的类加载模型，它不依赖任何第三方的类库，提供了一种模块化(Module)的类加载机制，它提供的如下方法可用来 加载 Service Provider

~~~
public <S> ServiceLoader<S> loadService(Class<S> serviceType)
public <S> ServiceLoader<S> loadServiceDirectly(Class<S> serviceType)
public static <S> ServiceLoader<S> loadServiceFromCallerModuleLoader(ModuleIdentifier identifier, Class<S> serviceType)
~~~

使用 JBoss Modules 加载 Service Provider 有两个步骤:

1. 实现 Service Provider
2. 加载 Service Provider

### 实现 Service Provider

在 Service Provider 对应的 class path 下创建目录 `META-INF/services/`，并在该目录下创建一个一 Service 名命名的文本文件(例如，一个 Service 对应的接口为 org.sample.Example, 则文本文件名为 org.sample.Example)，该文件中添加 Service 接口的实现类。

### 加载 Service Provider

加载 Service Provider 需要知道 Service Provider 对应模块的名字及实例化一个 Module 类:

~~~
ModuleIdentifier moduleId = ModuleIdentifier.create(moduleName);
Module module = Module.getBootModuleLoader().loadModule(moduleId);
ServiceLoader<T> services = module.loadService(type);
~~~

## JBoss Modules 加载 Service Provider 示例

### API - Service

~~~
public interface HelloWorld {
    String sayHello();
    Long getTimestamp();
}
~~~

### Impl - Service Provider

#### Service 接口实现

~~~
public class HelloWorldImpl implements HelloWorld{

    @Override
    public String sayHello() {
        return "Hello World";
    }

    @Override
    public Long getTimestamp() {
        return System.currentTimeMillis();
    }
}
~~~

#### Service Provider 配置文件

在当前 class path 下创建目录 `META-INF/services`.

在该目录下创建文本文件 `api.HelloWorld`，并添加如下内容

~~~
impl.HelloWorldImpl
~~~

### Server

#### 加载 Service

~~~
static <T> T buildService(Class<T> type, String moduleName) {
    final ModuleIdentifier moduleId;
    final Module module;
    try {
        moduleId = ModuleIdentifier.create(moduleName);
        module = Module.getBootModuleLoader().loadModule(moduleId); //If use Module.getCallerModuleLoader(), need set class loader as below method
    } catch (ModuleLoadException e) {
        throw new ClassLoadException(e);
    }
    ServiceLoader<T> services = module.loadService(type);
    Iterator<T> iter = services.iterator();
    if (!iter.hasNext()){
        throw new ServiceNotFoundException("Can not load " + type + " from " + moduleName);
    }
    return iter.next();
}
~~~

#### 运行 Service

~~~
HelloWorld service = buildService(HelloWorld.class, "impl");
service.sayHello();
service.getTimestamp();
~~~

### 示例代码下载编译运行

#### 下载

[load-services-example.zip]({{ site.baseurl }}/assets/download/files/load-services-example.zip)

#### 编译

编译依赖 Maven 3 和 Java 8。下载完成解压，通过如下命令完成编译

~~~
unzip load-services-example.zip
cd load-services
mvn clean install
~~~ 

编译完成会产生一个 `load-services-example-1.0.zip` 位于 dist/target 下。

#### 运行

~~~
unzip dist/target/load-services-example-1.0.zip -d example
cd example
./bin/run.sh
~~~
