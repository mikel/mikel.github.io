---
title: "PostgreSQL on Windows - Startup Errors"
author: Mikel Lindsaar
date: 2008-04-15
layout: home
redirect_from:
  - /2008/4/15/postgresql-on-windows-startup-errors
---
If you are using PostgreSQL on Windows and you get: **FATAL:
pre-existing shared memory block is still in use** Or you get: **HINT:
Check if there are any old server processes still running, and terminate
them.** errors, here is how you fix it.

What has happened is your postgres server has crashed some how, or
failed to start, and now it can't start again at all.

But you look through your task manager, and nothing is there that looks
like postgres.

Well, look again, you will probably find a "drwatson" process running,
owned by the postgres service account user.

Kill this task, and all will be good again.

blogLater

Mikel
