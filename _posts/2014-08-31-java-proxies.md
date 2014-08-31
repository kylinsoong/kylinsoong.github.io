---
layout: blog
title:  "Java Proxy Vehicle Example"
date:   2014-08-31 20:55:00
categories: java
permalink: /java-proxies
author: Kylin Soong
duoshuoid: ksoong20140831
---

Proxy objects are useful in many situations to act as an intermediary between a client object and a target object.

Usually, the proxy class is already available as Java bytecodes, having been compiled from the Java source file for the proxy class. When needed, the bytecodes for the proxy class are loaded into the Java Virtual Machine and proxy objects can then be instantiated. But, in some circumstances, it is useful to dynamically generate the bytecodes for the proxy class at runtime.

This example will look at the techniques for **dynamically generating proxies** in Java and the benefits of doing so.

## Vehicle Example With No Proxy

First, let's show a client interacting with a target object directly. Suppose we have an `IVehicle` interface as follows:

~~~
public interface IVehicle {
	public void start();
	public void stop();
	public void forward();
	public void reverse();
	public String getName();
}
~~~

Here's a Car class that implements the IVehicle interface:

~~~
public class Car implements IVehicle {

	private String name;

	public Car(String name) {
		this.name = name;
	}

	public void start() {
		System.out.println("Car " + name + " started");
	}

	public void stop() {
		System.out.println("Car " + name + " stoped");
	}

	public void forward() {
		System.out.println("Car " + name + " forwarded");
	}

	public void reverse() {
		System.out.println("Car " + name + " reversed");
	}

	public String getName() {
		return name;
	}
}
~~~

Client interacts with a Car Vehicle directly:

~~~
public class ClientWithNoProxy {

	public static void main(String[] args) {
		IVehicle v = new Car("Botar");
		v.start();
		v.forward();
		v.stop();
	}
}
~~~

![vehicle-no-proxy]({{ site.baseurl }}/assets/blog/vehicle-no-proxy.png)

Output for the vehicle example with no proxy:

~~~
Car Botar started
Car Botar forwarded
Car Botar stoped
~~~

## Vehicle Example With Proxy

Now let's have the client interact with the target object through a proxy. Remember that the main intent of a proxy is to control access to the target object, rather than to enhance the functionality of the target object. 

Ways that proxies can provide access control include:

* Synchronization
* Authentication
* Remote Access
* Lazy instantiation

Here's our VehicleProxy class:

~~~
public class VehicleProxy implements IVehicle {

	private IVehicle v;

	public VehicleProxy(IVehicle v) {
		this.v = v;
	}

	public void start() {
		System.out.println("VehicleProxy: Begin of start()");
		v.start();
		System.out.println("VehicleProxy: End of start()");
	}

	public void stop() {
		System.out.println("VehicleProxy: Begin of stop()");
		v.stop();
		System.out.println("VehicleProxy: End of stop()");
	}

	public void forward() {
		System.out.println("VehicleProxy: Begin of forward()");
		v.forward();
		System.out.println("VehicleProxy: End of forward()");
	}

	public void reverse() {
		System.out.println("VehicleProxy: Begin of reverse()");
		v.reverse();
		System.out.println("VehicleProxy: End of reverse()");
	}

	public String getName() {
		return v.getName();
	}
}
~~~

Client interacts with a Car Vehicle through a VehicleProxy.

~~~
public class ClientWithProxy {

	public static void main(String[] args) {
		IVehicle c = new Car("Botar");
		IVehicle v = new VehicleProxy(c);
		v.start();
		v.forward();
		v.stop();
	}
}
~~~

![vehicle-with-proxy]({{ site.baseurl }}/assets/blog/vehicle-with-proxy.png)

Output for the vehicle example with a proxy:

~~~
VehicleProxy: Begin of start()
Car Botar started
VehicleProxy: End of start()
VehicleProxy: Begin of forward()
Car Botar forwarded
VehicleProxy: End of forward()
VehicleProxy: Begin of stop()
Car Botar stoped
VehicleProxy: End of stop()
~~~

## Vehicle Example With Dynamic Proxy

Java supports the creation of dynamic proxy classes and instances. 

* **dynamic proxy class** is a class that implements a list of interfaces specified at runtime when the class is created. 
* **proxy interface** is an interface that is implemented by a proxy class.
* **proxy instance** is an instance of a proxy class.
* **invocation handler object:** Each proxy instance has an associated invocation handler object, which implements the interface InvocationHandler

A method invocation on a proxy instance through one of its proxy interfaces will be dispatched to the invoke() method of the instance's invocation handler.

To do our vehicle example with a dynamic proxy, we first need an invocation handler:

~~~
public class VehicleHandler implements InvocationHandler {

	public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
		System.out.println("Vehicle Handler: Invoking " + method.getName());
		return method.invoke(proxy, args);
	}

}
~~~

Notice how we use the Reflection API to invoke the proper method on our target object:

![vehicle-dynamic-proxy]({{ site.baseurl }}/assets/blog/vehicle-dynamic-proxy.png)

Client with Dynamic Proxy:

~~~
public class ClientWithDynamicProxy {

	public static void main(String[] args) {
		IVehicle c = new Car("Botar");
		ClassLoader loader = IVehicle.class.getClassLoader();
		IVehicle v = (IVehicle) Proxy.newProxyInstance(loader, new Class[]{IVehicle.class}, new VehicleHandler());
		v.start();
		v.forward();
		v.stop();
	}
}
~~~

Output for the vehicle example with a dynamic proxy:

~~~
Vehicle Handler: Invoking start
Car Botar started
Vehicle Handler: Invoking forward
Car Botar going forward
Vehicle Handler: Invoking stop
Car Botar stopped
~~~
