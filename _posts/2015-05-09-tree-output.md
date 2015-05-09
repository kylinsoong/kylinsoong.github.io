---
layout: blog
title:  "Algorithm used in tree output"
date:   2015-05-09 22:15:00
categories: java
permalink: /tree-output
author: Kylin Soong
duoshuoid: ksoong2015060901
---

In Linux System, tree command will dump a tree layout output, for example:

~~~
.
├── a
│   └── b
│       └── c
├── d
└── e
~~~

This article will look up the Algorithm for forming a tree layout output.

Assume there are 3 l3holder:

* l3holder_1 - "├──"
* l3holder_2 - "└──"
* l3holder_3 - "   "

and 2 l2holder

* l1holder_1 - "│"
* l1holder_2 = " "

Algorithm used for count prefix: 

~~~
prefix = (index -1) * (l1holder + l3holder_3) +  (l3holder + l1holder_2)
~~~

For the first section:
* index    - the deep of tree
* l1holder - if node have buddy node, l1holder_1 should be use, else l1holder_2 should be use

For the second section:
* l3holder - if node have buddy node and not the last node to be print, l3holder_1 should be use, else l3holder_2 should be use.

## A usage Example

[TreeRenderer](https://github.com/kylinsoong/CustomizedTools/blob/master/core/src/main/java/com/customized/tools/renderer/TreeRenderer.java) of [CustomizedTools](https://github.com/kylinsoong/CustomizedTools) project is a example, use this api can quick dump a tree layout output, below is a code snipets:

~~~
TreeNode<String> root = new TreeNode<>(".");
TreeNode<String> a = new TreeNode<>("a");
TreeNode<String> b = new TreeNode<>("b");
TreeNode<String> c = new TreeNode<>("c");
TreeNode<String> d = new TreeNode<>("d");
TreeNode<String> e = new TreeNode<>("e");
root.addChild(a);
a.addChild(b).addChild(c);
root.addChild(d);
root.addChild(e);
		
new TreeRenderer(root, new TerminalOutputDevice(System.out)).renderer();
~~~

