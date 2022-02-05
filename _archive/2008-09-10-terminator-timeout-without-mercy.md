---
title: "Terminator - Timeout without Mercy"
author: Mikel Lindsaar
date: 2008-09-10
layout: post
redirect_from:
  - /2008/9/10/terminator-timeout-without-mercy
---
If you have been following my posts on Ruby-Talk and Ruby on Rails and
even RSpec mailing list (and who wouldn't?! I mean, aside from my
mother) then you would have noticed I have been banging my head against
a brick wall on the subject of System calls not being handled by the
Timeout libraries in Ruby...

I've done a lot of work with this. I mean a lot.

So I thought I would share.

It all starts with a basic requirement I have, which is to replicate a
data set from one side of the planet to the other. This involves logging
into a database server remotely using ActiveRecord across some encrypted
VPNs, querying some tables, and then inside of a transaction,
replicating down certain data on certain rows.

The solution I have works well, I can replicate about 2-5 rows per
second across the link which is more than adequate (the dataset changes
upto about 100 rows per minute). The problem is that occasionally,
ActiveRecord's link to the remote database will hit a snag, then Ruby
will wait, and wait, and wait to Timeout.... This can take hours, and in
fact, sometimes, it never does timeout, leaving a zombie process.

To avoid multiple replication problems, I have lock files which prevent
further copies of the replicator firing up if it detects that one is
already running.

So, in the end, I get stuck with several replicators "running", all
hung, all waiting for a link to come back that never will, and no
replication happening. In the mean time, the rows are still changing and
I am getting backlogged. Leave it for a day and you are 80,000 rows
backlogged and people start asking questions and I start looking for old
travel tickets that I had 'forgotten about'.

But why does ruby do this?

Shouldn't the Timeout library protect us from such evilness?

Well, yes and no. The problem is because ruby uses Green threads. Green
threads mean that there is only one real Ruby process running on the
server, and it "internally" makes other "threads" that it schedules
within the main ruby process' kernel time. Green threads are very
efficient (they save a lot of context switching) but the problem is that
if you get a System call that 'blocks', then the kernel will stop
servicing your main ruby thread until your system call is complete, and
THIS means that the little 'Timeout.timeout(5) { my code }' block you
put in, will never get called...

And then you get a hang... forever.

I tried a couple of handlings, the first was the
[SystemTimer](http://ph7spot.com/articles/system_timer) library by
Philippe Hanrigou. This entry actually has a really good and simple
example of what Green threads and blocking system calls mean. If you
want to brush up, it is a good read.

But SystemTimer didn't work. It uses alarm signals which could have some
problems. But in my case, it didn't work and I still got never ending
timeouts.

So I asked again on the Ruby-Talk mailing list and [Ara T.
Howard](http://codeforpeople.com/) came back with a quick script that
created little homicidal external ruby processes to kill the ruby
process I was in if it didn't "make it" in time.

The approach was actually very clever, and it works!

What he did was go "We can't be sure that the existing Ruby process will
be able to nuke itself, so instead, lets start up another Ruby instance,
running on it's own, that has the PIDs of the ruby instance that spawned
it, and if the time runs out, do a system based kill TERM on the pids."

You could say that our little ruby processes have a license to kill.
Literally.

So I implemented his idea, found a couple of problems, gave back some
ideas, and he coded, I spec'd, tested and described and we released a
brand new gem...

#### The Terminator.

You can get it with;

``` sh
gem install terminator
```

Or grab the [source code.](http://codeforpeople.com/lib/ruby/terminator)

And how do you use it? Simple:

``` ruby
require 'terminator'
Terminator.terminate 1 do
  sleep 2
  puts "I'll never print"
end
```

This will never print because the terminator times out after 1 second,
which is before the sleep of 2 seconds inside the block. This will raise
a Terminator::Error, which you could catch and try again if you want.

This will always work. It is because we are starting a separate process
of Ruby (which has some minor overhead) that waits the specified number
of seconds and then just simple does a system kernel TERM on our
misbehaving process.

Why should you use it?

Well, if you are making ANY calls to external web services, external
databases, OpenID, Youtube, Google Maps... anything, then you should
have a fail fast policy in place and time out rapidly if these fail. As
these are external system calls, they will most likely not be caught by
Ruby's timeout.rb library... and that means that your application will
just hang, waiting for the call that never comes back.

It is much better to go "Ok, 2 seconds are up, no response, let's tell
the user to try again in a minute" and render an appropriate message,
than have the user frustratingly whack the reload button a few hundred
more times wondering why your application is not responding.

So yes, I think you should use Terminator.

Besides, how many other gems do you know that have the method
'plot_to_kill' ?

blogLater

Mikel

