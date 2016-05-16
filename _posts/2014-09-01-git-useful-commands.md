---
layout: blog
title:  "Git Useful commands"
date:   2014-09-01 20:55:00
categories: git
permalink: /git-commands
author: Kylin Soong
duoshuoid: ksoong20140901
---

This documents contain a series useful git commands and Frequent Questions and Answers.

* Table of contents
{:toc}


## Useful git commands 

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

* Delete a exist branch

~~~
git push origin --delete new
~~~

* Create a new branch

~~~
git checkout -b EAP-6.x
git push origin EAP-6.x
~~~

* revert a commit

~~~
git revert e86dc9e0ec0dc3b4481891134d5481af1389ea61
git push origin master
~~~

### An example of delete a branch

~~~
$ git branch -d kylin.dev
$ git push origin :kylin.dev
~~~

### An example of sync a branch with master

~~~
$ git checkout kylin.dev.1
$ git merge --no-ff master
$ git push origin kylin.dev.1
~~~

### An example of manage remote branchs

As below figure, this example will demonstrates how to operate remote branches, the main content including: clone remote repo, change remove repo, 2 ways to create branch(UI, command line), change remote branch.

![Git remote branch]({{ site.baseurl }}/assets/blog/git-branch-remote.png)

* Clone and push change

~~~
$ git clone git@github.com:CustomizedTools/cst-examples.git
$ cd cst-examples/
$ touch master
$ git add master
$ git commit -m "add master file to master"
$ git push origin master
~~~

* Create and pull branch

With the document [creating-and-deleting-branches-within-your-repository/](https://help.github.com/articles/creating-and-deleting-branches-within-your-repository/) create a branch V1, execute 'git pull' will pull V1 to local:

~~~
$ git pull
$ git branch -a
* master
  remotes/origin/HEAD -> origin/master
  remotes/origin/V1
  remotes/origin/master
~~~

* Checkout and Switch to V1, commit and push change

~~~
$ git checkout V1
$ git branch -a
* V1
  master
  remotes/origin/HEAD -> origin/master
  remotes/origin/V1
  remotes/origin/master
$ mv master V1
$ git commit -m "change from master to V1"
$ git push origin V1
~~~

* Create branch via commands, push new branch to remote

~~~
$ git checkout -b V2
$ git branch -a
  V1
* V2
  master
  remotes/origin/HEAD -> origin/master
  remotes/origin/V1
  remotes/origin/V2
  remotes/origin/master
$ git push origin V2
~~~

### An example of manage forked remote branches

Continue with above example, in this example we will demonstrates how to manage forked remote branches. Below is the example architecture:

![Git remote branch fork]({{ site.baseurl }}/assets/blog/git-branch-remote-fork.png) 

* Fork a repo

[https://help.github.com/articles/fork-a-repo/](https://help.github.com/articles/fork-a-repo/)

* Clone forked repo and show all branchs

~~~
$ git clone git@github.com:kylinsoong/cst-examples.git
$ cd cst-examples/
$ git branch -a
* master
  remotes/origin/HEAD -> origin/master
  remotes/origin/V1
  remotes/origin/V2
  remotes/origin/master
~~~ 

* Checkout V2, push change to Forked V2

~~~
$ git checkout V2
$ git branch -a
* V2
  master
  remotes/origin/HEAD -> origin/master
  remotes/origin/V1
  remotes/origin/V2
  remotes/origin/maste
$ touch readme
$ git add readme
$ git commit -m "add readme file"
$ git push origin V2
~~~

* Use pull request to push change to Remote branch

[https://help.github.com/articles/using-pull-requests/](https://help.github.com/articles/using-pull-requests/)

### Syncing a fork

[https://help.github.com/articles/syncing-a-fork/](https://help.github.com/articles/syncing-a-fork/) have detailed steps. The commands used including:

~~~
git remote -v
git remote add upstream https://github.com/ORIGINAL_OWNER/ORIGINAL_REPOSITORY.git

git fetch upstream
git checkout master
git merge upstream/master
git push origin master
~~~

## Question & Answer

### Q1. What is the difference between origin and upstream in github?

When a git branch -a command is done, some branches have a prefix of origin (remotes/origin/..) while others have a prefix of upstream (remotes/upstream/..) as below example:

~~~
$ git branch -a
* master
  remotes/origin/HEAD -> origin/master
  remotes/origin/V_0_1
  remotes/origin/V_0_2
  remotes/origin/master
  remotes/upstream/V_0_1
  remotes/upstream/V_0_2
  remotes/upstream/master
~~~

As [https://help.github.com/articles/fork-a-repo/](https://help.github.com/articles/fork-a-repo/), if a Repo be Forked, Cloned and sync be configured, it looks like

![Git origin upstream]({{ site.baseurl }}/assets/blog/git-origin-upstream.png)

* `upstream` generally refers to the original repo that you have forked
* `origin` is your fork: your own repo on GitHub, clone of the original repo of GitHub

You will use `upstream` to **fetch from the original repo** (in order to keep your local copy in sync with the project you want to contribute to).

You will use `origin` to **pull and push** since you can contribute to your own repo.

More details refer to [stackoverflow](http://stackoverflow.com/questions/9257533/what-is-the-difference-between-origin-and-upstream-in-github)

### Q2. How to create a patch with the latest 10 commits?

~~~
git format-patch -10 HEAD --stdout > 0001-last-10-commits.patch
~~~
