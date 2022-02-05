---
title: "Engine Yard Cloud Backups Generating Zero Length Backups"
author: Mikel Lindsaar
date: 2011-02-11
layout: post
redirect_from:
  - /2011/2/11/engine-yard-cloud-backups-generating-zero-length-backups
---
If your backups on EngineYard cloud are zero length, maybe it is a
permissions problem.

We have a client that uses EngineYard cloud and has more than one
application hitting the same database.

As part of this, he needs access, and it turns out that some of the
views and tables were not owned by the deploy user.

This causes the eybackup to backup a file that is zero length and push
it to the S3 backup but still return
`<em>`{=html}successfully`</em>`{=html}. This is a problem because a
cursory examination shows the backups are working all fine.

While EngineYard go about fixing this, the solution is simple, just make
sure the owner of all the tables in the system belong to the deploy
user, or alternatively make sure the deploy user can read all the tables
in the database.

If you are using postgres you can do this with a simple SQL command:

``` sql
psql> ALTER TABLE <table name> OWNER TO deploy;
```

MySQL has a similar simple command to handle this issue.

blogLater

Mikel

