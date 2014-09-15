---
layout: blog
title:  "Mysql 存储过程"
date:   2014-09-15 17:55:12
categories: database
permalink: /mysql-procedure
author: Kylin Soong
duoshuoid: ksoong2014091501
---

本文包括一个 Mysql 存储过程的简单示例。

## 创建测试表

本文示例存储过程中使用到表 employee，创建表 employee SQL 如下:

~~~
create table employee(
    emp_id int primary key not null,
    first_name varchar(25),
    last_name varchar(25),
    dept varchar(10),
    salary int
);
insert into employee values(1111, 'Kylin', 'Soong', 'BPM', 8000);
insert into employee values(1112, 'Kylin', 'Soong', 'BPM', 8000);
insert into employee values(1113, 'Kylin', 'Soong', 'BPM', 8000);
insert into employee values(1114, 'Kylin', 'Soong', 'BPM', 9000);
insert into employee values(1115, 'Kylin', 'Soong', 'BPM', 9000);
insert into employee values(1116, 'Kylin', 'Soong', 'BPM', 9000);
~~~

## 存储过程示例

如下为创建存储过程示例 SQL:

~~~
DELIMITER //
DROP PROCEDURE IF EXISTS employee_hos;
CREATE PROCEDURE employee_hos(
  IN con CHAR(20),
  OUT total INT)
BEGIN
  SELECT emp_id, first_name, last_name FROM employee WHERE dept = con;
  SELECT sum(salary) INTO total from employee WHERE dept = con;
END //
DELIMITER ;
~~~

使用如下 SQL 测试以上创建的存储过程:

~~~
call employee_hos('BPM', @total);
SELECT @total;
~~~

## JDBC 调运存储过程

如下代码端通过JDBC 调运上面创建的存储过程:

~~~
		Connection conn = JDBCUtil.getDriverConnection(JDBC_DRIVER, JDBC_URL, JDBC_USER, JDBC_PASS);
		
		CallableStatement cStmt = conn.prepareCall("{call employee_hos(?, ?)}");
		cStmt.setString(1, "BPM");
		cStmt.registerOutParameter(2, Types.INTEGER);
		
		boolean hadResults = cStmt.execute();
		while (hadResults){
			ResultSet rs = cStmt.getResultSet();
			int columns = rs.getMetaData().getColumnCount();
			for (int row = 1; rs.next(); row++) {
				System.out.print(row + ": ");
				for (int i = 0; i < columns; i++) {
					if (i > 0) {
						System.out.print(", ");
					}
					System.out.print(rs.getString(i + 1));
				}
				System.out.println();
			}
			rs.close();
			hadResults = cStmt.getMoreResults();
		}
		
		int outputValue = cStmt.getInt(2);
		System.out.println(outputValue);
		
		JDBCUtil.close(cStmt);
		JDBCUtil.close(conn);
~~~
