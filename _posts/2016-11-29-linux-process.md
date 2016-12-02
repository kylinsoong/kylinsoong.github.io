---
layout: blog
title:  "LINUX - Process Management"
date:   2016-11-29 18:41:12
categories: linux
permalink: /linux-process
author: Kylin Soong
duoshuoid: ksoong2016112802
excerpt: Terminate and control processes using signals, Monitor resource usage and system load due to process activity. Set nice levels on new and existing processes.
---

* Table of contents
{:toc}

## Killing Processes

### Process control using signals

A signal is a software interrupt delivered to a process. Signals report events to an executing program. Events that generate a signal can be an error, external event (e.g., I/O request or expired timer), or by explicit request (e.g., use of a signal-sending command or by keyboard sequence).

~~~
kill PID
kill -signal PID
kill -l
~~~

~~~
killall command_pattern
killall -signal command_pattern
killall -signal -u username command_pattern
~~~

~~~
pkill command_pattern
pkill -signal command_pattern
pkill -G GID command_pattern
pkill -P PPID command_pattern
pkill -t terminal_name -U UID command_pattern
~~~

* Command — Processes with a pattern-matched command name.
* UID — Processes owned by a Linux user account, effective or real.
* GID — Processes owned by a Linux group account, effective or real.
* Parent — Child processes of a specific parent process.
* Terminal — Processes running on a specific controlling terminal.

### Logging users out administratively

* The `w` command views users currently logged into the system and their cumulative activities. Use the `TTY` and `FROM` columns to determine the user's location.

~~~
# w
 05:03:23 up  4:27,  2 users,  load average: 0.00, 0.01, 0.05
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
kylin    pts/0    dhcp-128-24.nay. 00:37    3.00s  9.35s  0.15s sshd: kylin [priv]
root     pts/1    dhcp-192-57.pek. 00:47    4:14m  0.06s  0.06s -bash
~~~

## Monitoring Process Activity


## Using nice and renice to Influence Process Priority
