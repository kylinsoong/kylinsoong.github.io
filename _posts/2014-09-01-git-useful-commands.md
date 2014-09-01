---
layout: blog
title:  "Git Useful commands"
date:   2014-09-01 20:55:00
categories: git
permalink: /git-commands
author: Kylin Soong
duoshuoid: ksoong20140901
---

This documents contain a series useful git commands:

### Branch

* Show Current branch

~~~
git branch
~~~

* Show all branchs

~~~
git branch -a
~~~

* Switch to exist branch

~~~
git checkout master
~~~

### A git revert example

~~~
git revert e86dc9e0ec0dc3b4481891134d5481af1389ea61
git push origin master
~~~
