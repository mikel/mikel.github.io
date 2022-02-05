---
title: "How to reset a sequence with PostgreSQL"
author: Mikel Lindsaar
date: 2008-11-02
layout: post
redirect_from:
  - /2008/11/2/how-to-reset-a-sequence-with-postgresql
---


I would think that

``` sql
ALTER SEQUENCE sequence_name
      RESTART WITH (SELECT max(id) FROM table_name);
```

would work, but it doesn't. Use:

``` sql
SELECT SETVAL('sequence_name', (SELECT MAX(id) FROM table_name) + 1);
```

instead and you will be a lot more happier.

blogLater

Mikel

