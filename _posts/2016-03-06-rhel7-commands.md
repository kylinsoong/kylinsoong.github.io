---
layout: blog
title:  "Red Hat Enterprise Linux 7 Commands"
date:   2016-03-16 16:14:12
categories: linux
permalink: /rhel7-commands
author: Kylin Soong
duoshuoid: ksoong20160306
excerpt: This Document Contain a series useful Red Hat Enterprise Linux 7 commands.
---

* Table of contents
{:toc}

## Local and Remote Logins

**The ways of quiting shell Session:**

* `exit` command
* pressing `Ctrl+d`

### Using SSH Key-based Authentication

* Create an SSH key pair in local server

~~~
$ ssh-keygen 
Generating public/private rsa key pair.
Enter file in which to save the key (/home/kylin/.ssh/id_rsa): /home/kylin/.ssh/id_t_rsa                  
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/kylin/.ssh/id_t_rsa.
Your public key has been saved in /home/kylin/.ssh/id_t_rsa.pub.
...
~~~

* Send the SSH public key to the remote server

~~~
[kylin@ksoong ~]$ ssh-copy-id -i ~/.ssh/id_t_rsa.pub root@10.66.218.46
/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
root@10.66.218.46's password: 

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'root@10.66.218.46'"
and check to make sure that only the key(s) you wanted were added.
~~~

* Login into remote server

~~~
$ ssh root@10.66.218.46
~~~

### Creating and Viewing an SoS Report

* If currently working as a non-root user, switch to root.

~~~
$ su -
Password: 
~~~

* Run the sosreport command. This may take many minutes on larger systems.

~~~
# sosreport
~~~

* Change directory to /var/tmp, and unpack the archive.

~~~
# cd /var/tmp
# tar -xvJf sosreport-*.tar.xz
~~~

* Change directory to the resulting subdirectory and browse the files found there.

~~~
# cd sosreport-ksoong-20160306161748
~~~

## File System Navigation

![Linux File System]({{ site.baseurl }}/assets/blog/linux-file-system.png)

![Linux File System DESC]({{ site.baseurl }}/assets/blog/linux-file-system-desc.png)

### Command-Line File Management

* Create Files

~~~
$ touch song1.mp3 song2.mp3 song3.mp3 song4.mp3 song5.mp3
$ touch snap1.jpg snap2.jpg snap3.jpg snap4.jpg snap5.jpg
$ touch film1.avi film2.avi film3.avi film4.avi film5.avi
$ ls -l
~~~

* Move Files

~~~
$ mv song1.mp3 song2.mp3 song3.mp3 song4.mp3 song5.mp3 Music/
$ mv snap1.jpg snap2.jpg snap3.jpg snap4.jpg snap5.jpg Pictures/
$ mv film1.avi film2.avi film3.avi film4.avi film5.avi Videos/
$ ls -l Music/ Videos/ Pictures/
~~~

* Create Directories

~~~
$ mkdir friends family work
$ rmdir friends family work
~~~

### Making Links Between Files

This Section will demonstrate how to use hard links and soft links to make multiple names point to the same file.

1. The command `ln` creates new hard links to existing files. The command expects an existing file as the first argument, followed by one or more additional hard links.
2. The `ln -s` command creates a soft link, which is also called a "symbolic link". A soft link is not a regular file, but a special type of file that points to an existing file or directory. Unlike hard links, soft links can point to a directory, and the target to which a soft link points can be on a different file system.

* Create an additional hard link

~~~
# ln /usr/share/doc/qemu/qmp-commands.txt /root/qmp-commands.txt
~~~

* Verify the link count on the newly created link

~~~
# ls -l /root/qmp-commands.txt 
-rw-r--r--. 2 root root 65630 Nov 18  2013 /root/qmp-commands.txt
~~~

* Verify the link count on the original file

~~~
# ls -l /usr/share/doc/qemu/qmp-commands.txt 
-rw-r--r--. 2 root root 65630 Nov 18  2013 /usr/share/doc/qemu/qmp-commands.txt
~~~

* Create the soft link

~~~
# ln -s /tmp/ /root/tmpdir
~~~

* Verify the newly created link with

~~~
# ls -l
lrwxrwxrwx. 1 root root     5 Mar  6 16:06 tmpdir -> /tmp/
# cd tmpdir/
# ls -lR
~~~

## Users and Groups
