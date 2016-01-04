---
layout: blog
title:  "How to use Github Pages, Gitbook with your Github Repositories"
date:   2016-01-04 18:00:00
categories: git
permalink: /git-pages-books
author: Kylin Soong
duoshuoid: ksoong2016010401
excerpt: GitBook, Github Pages, Github Repositories, How to use Github Pages, Gitbook with your Github Repositories? 
---

* Table of contents
{:toc}

## Concepts

* **Github Repositories** - Github Repositories are where you'll work and collaborate on projects, more details refer to [github.com/](https://github.com/).
* **Github Pages** - Github Pages supply a easy way to create your personal website or project website in minutes, hosted directly from your GitHub repository, one github account or group can get one site, for example, [ksoong.org](http://ksoong.org/), [infinispan.org](http://infinispan.org/) are all build from Github Pages, more details refer to [pages.github.com](https://pages.github.com/).
* **GitBook** - GitBook is a modern publishing toolchain. Making both writing and collaboration easy, more details refer to [gitbook.com](https://www.gitbook.com/).

## Creating Project Pages via GitBook generated static site

The following steps are use to create a project page with GitBook generated static site. 

### Install gitbook

If you want to generate static site, gitbook is necessary, gitbook depend on node.js, make sure node.js are installed:

![Nodejs install version]({{ site.baseurl }}/assets/blog/nodejs-install.png)

Install gitbook via executing

~~~
$ npm install gitbook-cli -g
~~~

make sure gitbook installed

![Gitbook install version]({{ site.baseurl }}/assets/blog/gitbook-install-version.png)

### Create SUMMARY.md for pages indexs

GitBook uses a `SUMMARY.md` file to define the structure of chapters and subchapters, for example [**teiid-embedded-examples**](https://github.com/kylinsoong/teiid-embedded-examples) has define a `SUMMARY.md` as below:

![gitbooks example summary]({{ site.baseurl }}/assets/blog/gitbook-example-summary.png)

A `README.md` file also is necessary, more details refer to [help.gitbook.com](https://help.gitbook.com/format/introduction.html).

### Generate static site

Execute `gitbook serve` commands will generate a static site

![gitbooks example serve]({{ site.baseurl }}/assets/blog/gitbook-example-serve.png)

> NOTE: once build success, `_book` folder generated which contain static site, you can view static site via [http://localhost:4000/](http://localhost:4000/).

### Push genetated static site to gh-pages branch

Once you have a clean repository, you'll need to create the new gh-pages branch and remove all content from the working directory and index:

~~~
$ git checkout --orphan gh-pages
$ git rm -rf 
$ mv _book/* ./
$ rm -fr _book
$ git commit -m "First pages commit"
$ git push origin gh-pages
~~~

Once above steps finished, Project Pages be added to your Github Pages website with path: `http(s)://<username>.github.io/<projectname>`. For example, access [http://ksoong.org/teiid-embedded-examples/](http://ksoong.org/teiid-embedded-examples/) will get [kylinsoong/teiid-embedded-examples](https://github.com/kylinsoong/teiid-embedded-examples) project pages.

## Gitbook writing and collaboration via Github Repository's Webhooks 

In Gitbook, each book can reference a webhook to a exist Github Repository, once the content of Github Repository be updated, Gitbook will execute a build and redeploy. The following is a example to demonstrate Webhooks.

### Create a document repository

[https://github.com/kylinsoong/document](https://github.com/kylinsoong/document) is a repository which hold the content of book [https://teiid.gitbooks.io/document/content/index.html](https://teiid.gitbooks.io/document/content/index.html), note that `SUMMARY.md` define the chapters and `README.md` define introfuction page.

### Add webhook to a Gitbook book

The following 4 steps are necessary to add webhook to a Gitbook book:

* Open the GitHub section in your book settings
* Enter your repository id: kylinsoong/document
* Save your settings
* Click on the button **Add a deployment webhook**

Once above 4 steps completed, webhook be add success, you can verify via Github Repository -> Settings -> Webhooks & services, you will see

![gitbooks example webhook]({{ site.baseurl }}/assets/blog/gitbook-example-webhook.png)

### Update Github Repository and verify change

Edit the markdown docs under content repository

~~~
$ git clone git@github.com:kylinsoong/document.git
$ cd document
$ vim README.md
$ git add README.md
$ git commit -m "update readme"
$ git push origin master
~~~

Verify change from 

~~~
https://teiid.gitbooks.io/document/content/index.html
~~~
