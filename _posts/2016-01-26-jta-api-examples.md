---
layout: blog
title:  "Java Transaction API & Examples"
date:   2016-01-20 12:00:12
categories: javaee
author: Kylin Soong
duoshuoid: ksoong2016012601
---

This page contain examples of Java Transaction API.

* Table of contents
{:toc}

## TransactionManager

The `javax.transaction.TransactionManager` interface defines the methods that allow an application server to manage transactions on behalf of the applications.

### begin(), commit()

~~~
TransactionManager tm = getTransactionManager();
tm.begin();
tm.commit();
~~~

### begin(), rollback()

~~~
TransactionManager tm = getTransactionManager();
tm.begin();
tm.rollback();
~~~

### begin(), setRollbackOnly(), commit()

~~~
TransactionManager tm = getTransactionManager();
tm.begin();
tm.setRollbackOnly();
tm.commit();
~~~ 

> NOTE: this will throw `javax.transaction.RollbackException`

### begin(), getStatus(), commit()

~~~
TransactionManager tm = getTransactionManager();
tm.begin();
System.out.println(Status.STATUS_ACTIVE == tm.getStatus());
tm.commit();
System.out.println(Status.STATUS_NO_TRANSACTION == tm.getStatus());
~~~

Run this code will output:

~~~
true
true
~~~

### setTransactionTimeout(), begin(), commit()

~~~
TransactionManager tm = getTransactionManager();
tm.setTransactionTimeout(3);
tm.begin();
Thread.sleep(1000 * 5);
tm.commit();
~~~

> NOTE: this will throw `javax.transaction.RollbackException`

### begin(), getTransaction()

~~~
TransactionManager tm = getTransactionManager();
tm.begin();
Transaction t = tm.getTransaction();
~~~

## Synchronization

The The transaction manager supports a `javax.transaction.Synchronization` that allows the interested party to be notified before and  after the transaction completes. Using the registerSynchronization method, the application server registers a Synchronization object for the transaction currently associated with the target Transaction object.

~~~
TransactionManager tm = getTransactionManager();
tm.begin();
Transaction t = tm.getTransaction();
t.registerSynchronization(new Synchronization(){

    @Override
    public void beforeCompletion() {
        System.out.println("transaction before completion");
    }

    @Override
    public void afterCompletion(int status) {
        System.out.println("transaction after completion, status: " + status);
    }
            
});
tm.commit(); 
~~~ 

Run this code will output:

~~~
transaction before completion
transaction after completion, status: 3
~~~

> NOTE: status is 3 means `STATUS_COMMITTED`.
