---
title: "Upgrading SVN on OpenBSD - relink your binary => libthread.so"
author: Mikel Lindsaar
date: 2007-11-26
layout: home
redirect_from:
  - /2007/11/26/upgrading-svn-on-openbsd-relink-your-binary-libthread-so
---
Today I upgraded the SVN on my server for 1.4.3 to 1.4.5 and got this
strange error:

svn:/usr/lib/libpthread.so.6.3: /usr/lib/libpthread.so.7.0 : WARNING:
symbol(\_thread_kern_thread) size mismatch, relink your program

How RUDE!

I spent a while googling around and found nothing that even remotely
handled the problem.

So in the end... I resorted to the final, desperate measure.

Yes...

I did it.

I actually *READ* the error message?![](?)?!

I know... it's radical! Sort of strange, and something I shouldn't hide
in the closet, but really, it worked!

You see, the problem is SVN was complaining about libthread.so

The only thing I knew of on my server that was needing a link into SVN
via a module was Apache.

So, I restarted Apache and sure enough, SAME error!

Ah Ha!

Now I was down to something to do with Apache and SVN that was out of
step with each other. At this point it became a bit of a no brainer,
just re-compile Apache.

Like any good sysadmin, I keep any source tree around that I have
compiled into my system with the saved ./configure still left in there.
So doing this was as simple as:

``` ruby
# cd /usr/local/src/httpd-2.2.3
# make clean
# make
# make install
```

Once I finished that, I rebuilt SVN and installed (with the same method)
and now everything works.

Handy.

blogLater

Mikel
