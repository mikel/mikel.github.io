---
title: "Tip #25 - Logging is your friend..."
author: Mikel Lindsaar
date: 2008-06-25
layout: post
redirect_from:
  - /2008/6/25/tip-25-rspec-tip
  - /2008/6/24/tip-25-rspec-tip
---
Sometimes when you need someone to just look over your code and figure
out what the heck is going on, you can turn to your best coding friend,
this friend sits away in the log directory carefully collecting data
waiting for your beck and call...

### Watch your log files.

This should sort of be obvious, but I know several people (including
yours truly) who have been bitten by this one.

When you are running your specifications, keep a 'tail -f log/test.log'
running. If you are on Windows and can't do this, then either install
cygwin so that you can, or make your system dual boot with Ubuntu or
something so you can.

The logs will tell you a huge amount about what your app is trying to do
when. This is especially true if you get a controller spec response
along the lines of:

``` rspec
1)
'PeopleController handling GET /people should render index template' FAILED
expected "index", got nil
./spec/controllers/people_controller_spec.rb:54:
script/spec:4:

2)
'PeopleController handling GET /people/new should render new template' FAILED
expected "new", got nil
./spec/controllers/people_controller_spec.rb:60:
script/spec:4:
```

I expected the new template, but got nil... not very helpful...

But in the logs, the truth appears:

``` sh
Processing PeopleController#index (for 0.0.0.0 at 2008-06-25 09:15:28) [GET]
  Session ID: 
  Parameters: {"action"=>"index", "controller"=>"people"}
Filter chain halted as [:must_login] rendered_or_redirected.
Completed in <snip> | 200 OK [http://test.host/people]

Processing PeopleController#index (for 0.0.0.0 at 2008-06-25 09:15:28) [GET]
  Session ID: 
  Parameters: {"action"=>"new", "controller"=>"people"}
Filter chain halted as [:must_login] rendered_or_redirected.
Completed in <snip> | 200 OK [http://test.host/people]
```

Ahh! Filter chain halted as the must_login method returned false! So we
forgot to log in before we went to try and get the controller action.

Simple example, I know... but aren't all the good tips simple?

Mikel

