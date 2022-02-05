---
title: "Copying an SQLServer Database"
author: Mikel Lindsaar
date: 2007-11-30
layout: post
redirect_from:
  - /2007/11/30/copying-an-sqlserver-database
---
When you are testing and developing code, you don't want to be playing
with a live database at all, this is how you copy it to your local
system.

First install the SQL management Studio and SQLServer onto your local
computer. This should be the same one as you are running on your server.

This is pretty easy.

Then you have to copy your live database down to your local PC's SQL
Server. Usually, the live database is just that, live, so you don't want
to take it off line to copy. Here is how you do it and keep everything
rolling along.

#### Step one - Setup

SQL Server does the copy using something called the SQL Server Agent.
This is a service that runs on your local machine that interacts with
SQL Servers on your behalf. This service has to have a login username
and password that can lot into the source and destination servers with
sufficient permissions to copy everything and create everything.

The way you set this is go into Control Panel -\> Administration Tools
-\> Services. Scroll down to the SQL Server Agent, double click it, go
into the Log On pane and enter a username and password that has rights
to both servers. You will have to figure out what this is for your own
site.

#### Step two - Do the copy

Now, open up the source server in SQL Server Manager and right click on
the database in question, then click "Tasls" and click on the "Copy
Database" option.

You will be prompted with a welcome screen, click "Don't show this
again" and hit next.

Then you will have to choose the source server, set this up. You can
choose Windows Auth or SQL Server Auth. This is a decision you will need
to make depending on how you authenticate, either way, fill in the
details and hit next.

Now a destination server, in our case, "local" which is the default is
fine.

Then, you have two choices: (1) Detatch and attach model or (2) SQL
Management Object model.

In our case we want #2, the SQL Management Object model as this keeps
the main server online while we do the copy. This sometimes fails, in
which case you should try again. The Detatch version is the best IF you
can take your server off line, for the rest of us, choose the second
option.

Next screen, choose the source database. Make sure the tick is under the
C for Copy column, not under the M for Move column!!!!

Now type in a destination database name. Whatever you want. You might
also want to select the bottom "Drop anything with the same name"
option, or you might not, your choice.

Now you have to choose what to copy, I generally take everything, stored
procedures, error codes the lot. This is because I want to test on a
live actual copy. You should probably do the same.

Then the next two screens ask you when you want to run it (yes, now
would be good) and also about where and how you want to log any errors.

I tend to log to a file in C:\\ and to a text file. This is usually
easier to read and see afterwards if it fails.

Then a summary screen will come up, hit next and the copy should start.

#### What to do if it fails.

Well, look at the log file :)

You will generally find it is one of two things:

1.  Authentication error - you can handle this by fixing the login name
    and password for the SQL Agent service listed in step one. Note, you
    need to stop and restart the service if you change this for the
    settings to take effect.
2.  Errors in the copying - check the error log to find where it
    actually died at the end of the file. This should point you in the
    right direction.

Good luck!

Mikel

