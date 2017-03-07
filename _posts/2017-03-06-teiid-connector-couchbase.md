---
layout: blog
title:  "Teiid Couchbase Connector"
date:   2017-03-06 18:00:00
categories: teiid
permalink: /teiid-connector-couchbase
author: Kylin Soong
duoshuoid: ksoong2017030601
excerpt: The Teiid connector for Couchbase connects Couchbase to the JBoss Data Viirtualization Platform. 
---

* Table of contents
{:toc}

## Defining a Schema

The data stored in Couchbase are JSON documents, each document may contain:

* key pair with no typed value
* nested arrays 
* arrays of differently-typed elements  
* nested documents which contain above 3 scenarios

which does not follow the rules of data typing and structure that apply to traditional relational tables and columns. To map the documents to a relational form, the Teiid Couchbase connector will generates a database schema that maps the Couchbase data to a JDBC-compatible format. Simply, this be done in Teiid Connector's MetadataProcessor load the Metadata.

### Principles for mapping documents to JDBC-compatible Tables

1. The keyspace/bucket be mapped as top table which contains all key/value pairs not include the nested arrays/documents, key be mapped to column name, the value type be mapped to column type
2. The nested arrays/documents be mapped to different table with name: `the parent table` + `underscore character` + `the key of nested arrays/documents`
3. Each Table has a PK column map the document id, the PK in top table is primary key.
4. If a nested array has a nested array item, the array item item be treated as Object.

### An Example of Schema Definition

There are documents `Customer` and `Order` under Bucket `test`:

**Customer**

![Cusomter]({{ site.baseurl }}/assets/blog/teiid/teiid-couchbase-customer.png)

**Order**

![Order]({{ site.baseurl }}/assets/blog/teiid/teiid-couchbase-order.png)

The above documents will map to 4 tables: `test`, `test_CreditCard`, `test_Items`, `test_SavedAddresses`.

![test]({{ site.baseurl }}/assets/blog/teiid/teiid-couchbase-mapped-test.png)

![test_CreditCard]({{ site.baseurl }}/assets/blog/teiid/teiid-couchbase-mapped-test_CreditCard.png)

![test_Items]({{ site.baseurl }}/assets/blog/teiid/teiid-couchbase-mapped-test_Items.png)

![test_SavedAddresses]({{ site.baseurl }}/assets/blog/teiid/teiid-couchbase-mapped-test_SavedAddresses.png)





