---
layout: blog
title:  "Java Future FutureTask 示例"
date:   2015-01-06 11:30:00
categories: java
permalink: /java-future
author: Kylin Soong
duoshuoid: ksoong2015010601
---

Future 类位于 java.util.concurrent 包下，它是一个接口：

~~~
public interface Future<V> {
    boolean cancel(boolean mayInterruptIfRunning);
    boolean isCancelled();
    boolean isDone();
    V get() throws InterruptedException, ExecutionException;
    V get(long timeout, TimeUnit unit) throws InterruptedException, ExecutionException, TimeoutException;
}
~~~

在 Future 接口中声明了5个方法，下面依次解释每个方法的作用：

* cancel方法用来取消任务，如果取消任务成功则返回true，如果取消任务失败则返回false。参数mayInterruptIfRunning表示是否允许取消正在执行却没有执行完毕的任务，如果设置true，则表示可以取消正在执行过程中的任务。如果任务已经完成，则无论mayInterruptIfRunning为true还是false，此方法肯定返回false，即如果取消已经完成的任务会返回false；如果任务正在执行，若mayInterruptIfRunning设置为true，则返回true，若mayInterruptIfRunning设置为false，则返回false；如果任务还没有执行，则无论mayInterruptIfRunning为true还是false，肯定返回true。
* isCancelled方法表示任务是否被取消成功，如果在任务正常完成前被取消成功，则返回 true。
* isDone方法表示任务是否已经完成，若任务完成，则返回true；
* get()方法用来获取执行结果，这个方法会产生阻塞，会一直等到任务执行完毕才返回；
* get(long timeout, TimeUnit unit)用来获取执行结果，如果在指定时间内，还没获取到结果，就直接返回null

也就是说 Future 提供了三种功能：**判断任务是否完成**, **能够中断任务**, **能够获取任务执行结果**.

FutureTask 为 RunnableFuture 接口的实现类，同位于 java.util.concurrent 包下，它的 UML 类图如下：

![UML of FutureTask]({{ site.baseurl }}/assets/blog/java-uml-future.png)

可以看出 RunnableFuture 继承了 Runnable 接口和 Future 接口，而 FutureTask 实现了 RunnableFuture 接口。所以它既可以作为 Runnable 被线程执行，又可以作为 Future 得到 Callable 的返回值。

FutureTask 提供了2个构造方法：

~~~
public FutureTask(Callable<V> callable) {}
public FutureTask(Runnable runnable, V result) {}
~~~

### 案例一: Callable + Future 获取执行结果示例

Task 类实现了 Callable 接口

![Example.1 - Task]({{ site.baseurl }}/assets/blog/java-future-example-1-task.png)

call() 方法执行到 27 行 sleep 5 秒钟，然后进行 1 到 100 累加。

![Example.1 - Run]({{ site.baseurl }}/assets/blog/java-future-example-1-run.png)

如上代码，创建一个线程池，执行 Callable Task，通过返回的 Future 结果测试 Future 的 get() 方法。程序运行输出结果：

~~~
子线程在进行计算
主线程在执行任务
task运行结果4950
所有任务执行完毕
~~~

[完整代码](https://raw.githubusercontent.com/kylinsoong/JVM/master/jdk/concurrent/src/main/java/org/ksoong/tutorial/java/concurrent/future/TestFuture.java) 

### 案例二: Callable + Future 以及判断任务是否完成示例

Task 类实现了 Callable 接口

![Example.2 - Task]({{ site.baseurl }}/assets/blog/java-future-example-2-task.png)

call() 方法执行到 27 行 sleep 20 秒钟，然后进行 1 到 100 累加。

![Example.2 - Run]({{ site.baseurl }}/assets/blog/java-future-example-2-run.png)

如上代码，创建一个线程池，执行 Callable Task，通过返回的 Future 结果测试 Future 的 isDone(), isCancelled(), get(long timeout, TimeUnit unit) 等方法。程序运行输出结果：

~~~
子线程在进行计算
主线程在执行任务
task 是否结束: false
task 是否取消: false
task 运行出错: java.util.concurrent.TimeoutException
task 是否结束: true
task 是否取消: true
~~~

[完整代码](https://raw.githubusercontent.com/kylinsoong/JVM/master/jdk/concurrent/src/main/java/org/ksoong/tutorial/java/concurrent/future/TestFuturePlus.java)

### 案例三: Callable + FutureTask 获取执行结果示例

Task 类实现了 Callable 接口

![Example.3 - Task]({{ site.baseurl }}/assets/blog/java-future-example-1-task.png)

call() 方法执行到 27 行 sleep 5 秒钟，然后进行 1 到 100 累加。

![Example.3 - Run]({{ site.baseurl }}/assets/blog/java-future-example-3-run.png)

如上代码，创建一个 FutureTask，Callable Task作为构造函数的参数，随后启动一个线程并启动执行 FutureTask，测试 FutureTask 的 get() 方法。程序运行输出结果：

~~~
子线程在进行计算
主线程在执行任务
task运行结果4950
所有任务执行完毕
~~~

[完整代码](https://raw.githubusercontent.com/kylinsoong/JVM/master/jdk/concurrent/src/main/java/org/ksoong/tutorial/java/concurrent/future/TestFutureTask.java)

### 案例四: Callable + FutureTask 以及判断任务是否完成示例

Task 类实现了 Callable 接口

![Example.4 - Task]({{ site.baseurl }}/assets/blog/java-future-example-2-task.png)

call() 方法执行到 27 行 sleep 5 秒钟，然后进行 1 到 100 累加。

![Example.4 - Run]({{ site.baseurl }}/assets/blog/java-future-example-4-run.png)

如上代码，创建一个 FutureTask，Callable Task作为构造函数的参数，随后启动一个线程并启动执行 FutureTask，测试 FutureTask 的 isDone(), isCancelled(), get(long timeout, TimeUnit unit) 等方法。程序运行输出结果：

~~~
子线程在进行计算
主线程在执行任务
task 是否结束: false
task 是否取消: false
task 是否结束: true
task 是否取消: true
任务取消
~~~

[完整代码](https://raw.githubusercontent.com/kylinsoong/JVM/master/jdk/concurrent/src/main/java/org/ksoong/tutorial/java/concurrent/future/TestFutureTaskPlus.java)

### 案例五: Runnable + FutureTask 获取执行结果示例

Task 类实现了 Runnable 接口，且它又一个 Result 属性为构造方法的参数

![Example.5 - Task]({{ site.baseurl }}/assets/blog/java-future-example-5-task.png)

run() 方法执行到 42 行 sleep 5 秒钟，然后进行 1 到 100 累加。

![Example.5 - Run]({{ site.baseurl }}/assets/blog/java-future-example-5-run.png)

如上代码，创建一个 FutureTask，Runnable Task 和 Result 作为构造函数的参数，随后启动一个线程并启动执行 FutureTask，测试 FutureTask 的 get(t) 方法。程序运行输出结果：

~~~
子线程在进行计算
主线程在执行任务
task运行结果4950
所有任务执行完毕
~~~

[完整代码](https://raw.githubusercontent.com/kylinsoong/JVM/master/jdk/concurrent/src/main/java/org/ksoong/tutorial/java/concurrent/future/TestFutureTaskRunnable.java)

