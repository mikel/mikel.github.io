---
title: "Tip #29 - Stop a Mongrel (or any) Service in Windows"
author: Mikel Lindsaar
date: 2009-12-22
layout: post
redirect_from:
  - /2009/12/22/tip-29-stop-a-mongrel-or-any-service-in-windows
  - /2009/12/23/tip-29-stop-a-mongrel-or-any-service-in-windows
---
If you are running a rails app on Windows Server (**GASP**) then you
will run into the problem of how to restart your apps?

I had this problem when I had to deploy an app on a Windows server. It
wasn't a lot of fun, but it is possible, and the app is actually quite
stable.

To restart a service, you need to talk to the Service Control Manager
(SCM in windows). Windows Server provides a utility called "sc" which
communicates and allows you interact with the SCM.

Say you installed your mongrel service and called it (unimaginatively
enough) Mongrel_1. Well, you could type this and get the following data:

``` shell
c:\WINNT> sc
```

This will give you all the help you need for the Service Control
Manager.

But the simple style to stop a service called "Mongrel1" is:

``` shell
c:\WINNT> sc stop Mongrel1
```

This will find the service called Mongrel1 and then sent a stop command
to it. To find out what your services are called, go into the services
control panel, right click on the Service you want to find the name of
and then select properties, it will be listed under "Service name".

You can do a bunch of other things with the sc command, restart
services, start new ones, pause services and even change the config of
the services (description etc). It is worth a look and gives you a good
batch file way to start and stop services in windows.

Good luck! (and try to migrate away from windows for Rails as soon as
you can :)

blogLater

Mikel

