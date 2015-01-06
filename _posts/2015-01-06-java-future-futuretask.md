---
layout: blog
title:  "Java Future FutureTask 示例"
date:   2015-01-06 11:30:00
categories: java
permalink: /java-future
author: Kylin Soong
duoshuoid: ksoong2015010601
---

Future类位于java.util.concurrent包下，它是一个接口：

~~~
public interface Future<V> {
    boolean cancel(boolean mayInterruptIfRunning);
    boolean isCancelled();
    boolean isDone();
    V get() throws InterruptedException, ExecutionException;
    V get(long timeout, TimeUnit unit) throws InterruptedException, ExecutionException, TimeoutException;
}
~~~

在Future接口中声明了5个方法，下面依次解释每个方法的作用：

* cancel方法用来取消任务，如果取消任务成功则返回true，如果取消任务失败则返回false。参数mayInterruptIfRunning表示是否允许取消正在执行却没有执行完毕的任务，如果设置true，则表示可以取消正在执行过程中的任务。如果任务已经完成，则无论mayInterruptIfRunning为true还是false，此方法肯定返回false，即如果取消已经完成的任务会返回false；如果任务正在执行，若mayInterruptIfRunning设置为true，则返回true，若mayInterruptIfRunning设置为false，则返回false；如果任务还没有执行，则无论mayInterruptIfRunning为true还是false，肯定返回true。
* isCancelled方法表示任务是否被取消成功，如果在任务正常完成前被取消成功，则返回 true。
* isDone方法表示任务是否已经完成，若任务完成，则返回true；
* get()方法用来获取执行结果，这个方法会产生阻塞，会一直等到任务执行完毕才返回；
* get(long timeout, TimeUnit unit)用来获取执行结果，如果在指定时间内，还没获取到结果，就直接返回null

也就是说Future提供了三种功能：

* 判断任务是否完成；
* 能够中断任务；
* 能够获取任务执行结果。

接下来我们看FutureTask的实现：

~~~
public class FutureTask<V> implements RunnableFuture<V>
~~~

FutureTask类实现了RunnableFuture接口，我们看一下RunnableFuture接口的实现：

~~~
public interface RunnableFuture<V> extends Runnable, Future<V> {
    void run();
}
~~~

可以看出RunnableFuture继承了Runnable接口和Future接口，而FutureTask实现了RunnableFuture接口。所以它既可以作为Runnable被线程执行，又可以作为Future得到Callable的返回值。

FutureTask提供了2个构造方法：

~~~
public FutureTask(Callable<V> callable) {
}
public FutureTask(Runnable runnable, V result) {
}
~~~

## Callable + Future 获取执行结果示例

~~~
public class TestFuture {

	public static void main(String[] args) throws InterruptedException, ExecutionException {

		ExecutorService executor = Executors.newCachedThreadPool();
        Task task = new Task();
        Future<Integer> result = executor.submit(task);
        executor.shutdown();
        
        Thread.sleep(1000);
      
        System.out.println("主线程在执行任务");
        
        System.out.println("task运行结果" + result.get());
         
        System.out.println("所有任务执行完毕");
	}
	
	static class Task implements Callable<Integer> {

		@Override
		public Integer call() throws Exception {
			System.out.println("子线程在进行计算");
	        Thread.sleep(5000);
	        int sum = 0;
	        for(int i=0;i<100;i++) {
	        	sum += i;
	        }
	        return sum;
		}
		
	}

}
~~~

执行结果：

~~~
子线程在进行计算
主线程在执行任务
task运行结果4950
所有任务执行完毕
~~~

## Callable + Future 以及判断任务是否完成示例

~~~
public class TestFuturePlus {

	public static void main(String[] args) throws InterruptedException, ExecutionException {

		ExecutorService executor = Executors.newCachedThreadPool();
        Task task = new Task();
        Future<Integer> result = executor.submit(task);
        executor.shutdown();
        
        Thread.sleep(1000);
      
        System.out.println("主线程在执行任务");
        
        System.out.println("task 是否结束: " + result.isDone());
        System.out.println("task 是否取消: " + result.isCancelled());
        try {
			System.out.println("task运行结果" + result.get(1000, TimeUnit.MICROSECONDS));
		} catch (TimeoutException e) {
		}
        result.cancel(true);
        System.out.println("task 是否结束: " + result.isDone());
        System.out.println("task 是否取消: " + result.isCancelled());
        
	}
	
	static class Task implements Callable<Integer> {

		@Override
		public Integer call() throws Exception {
			System.out.println("子线程在进行计算");
	        Thread.sleep(20000);
	        int sum = 0;
	        for(int i=0;i<100;i++) {
	        	sum += i;
	        }
	        return sum;
		}
		
	}

}
~~~

执行结果：

~~~
子线程在进行计算
主线程在执行任务
task 是否结束: false
task 是否取消: false
task 是否结束: true
task 是否取消: true
~~~

## Callable + FutureTask 获取执行结果示例

~~~
public class TestFutureTask {

	public static void main(String[] args) throws InterruptedException, ExecutionException {

		Task task = new Task();
        FutureTask<Integer> futureTask = new FutureTask<Integer>(task);
        Thread thread = new Thread(futureTask);
        thread.start();
        
        Thread.sleep(1000);
      
        System.out.println("主线程在执行任务");
        
        System.out.println("task运行结果" + futureTask.get());
         
        System.out.println("所有任务执行完毕");
	}
	
	static class Task implements Callable<Integer> {

		@Override
		public Integer call() throws Exception {
			System.out.println("子线程在进行计算");
	        Thread.sleep(5000);
	        int sum = 0;
	        for(int i=0;i<100;i++) {
	        	sum += i;
	        }
	        return sum;
		}
		
	}

}
~~~

执行结果：

~~~
子线程在进行计算
主线程在执行任务
task运行结果4950
所有任务执行完毕
~~~

## Callable + FutureTask 以及判断任务是否完成示例

~~~
public class TestFutureTaskPlus {

	public static void main(String[] args) throws InterruptedException, ExecutionException {

		Task task = new Task();
        FutureTask<Integer> futureTask = new FutureTask<Integer>(task);
        Thread thread = new Thread(futureTask);
        thread.start();
        
        Thread.sleep(1000);
      
        System.out.println("主线程在执行任务");
        
        System.out.println("task 是否结束: " + futureTask.isDone());
        System.out.println("task 是否取消: " + futureTask.isCancelled());
        try {
			System.out.println("task运行结果" + futureTask.get(1000, TimeUnit.MICROSECONDS));
		} catch (TimeoutException e) {
		}
        futureTask.cancel(true);
        System.out.println("task 是否结束: " + futureTask.isDone());
        System.out.println("task 是否取消: " + futureTask.isCancelled());
        
        System.out.println("任务取消");
	}
	
	static class Task implements Callable<Integer> {

		@Override
		public Integer call() throws Exception {
			System.out.println("子线程在进行计算");
	        Thread.sleep(20000);
	        int sum = 0;
	        for(int i=0;i<100;i++) {
	        	sum += i;
	        }
	        return sum;
		}
		
	}

}
~~~

执行结果：

~~~
子线程在进行计算
主线程在执行任务
task 是否结束: false
task 是否取消: false
task 是否结束: true
task 是否取消: true
任务取消
~~~

## Runnable + FutureTask 获取执行结果示例

~~~
public class TestFutureTaskRunnable {

	public static void main(String[] args) throws InterruptedException, ExecutionException {
		Result result = new Result();
		Task task = new Task(result);
        FutureTask<Result> futureTask = new FutureTask<Result>(task, result);
        Thread thread = new Thread(futureTask);
        thread.start();
        
        Thread.sleep(1000);
        
        System.out.println("主线程在执行任务");
        
        System.out.println("task运行结果" + futureTask.get());
         
        System.out.println("所有任务执行完毕");

	}
	
	static class Result {
		public int result;

		@Override
		public String toString() {
			return result + "";
		}
	}
	
	static class Task implements Runnable {
		private Result result;

		public Task(Result result) {
			super();
			this.result = result;
		}

		@Override
		public void run() {
			System.out.println("子线程在进行计算");
	        try {
				Thread.sleep(5000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	        int sum = 0;
	        for(int i=0;i<100;i++) {
	        	sum += i;
	        }
	        result.result = sum;
		}
		
	}

}
~~~

执行结果：

~~~
子线程在进行计算
主线程在执行任务
task运行结果4950
所有任务执行完毕
~~~

