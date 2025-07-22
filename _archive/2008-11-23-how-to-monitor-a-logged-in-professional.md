---
title: "How to monitor a logged in professional"
author: Mikel Lindsaar
date: 2008-11-23
layout: home
redirect_from:
  - /2008/11/23/how-to-monitor-a-logged-in-professional
---
Sometimes you will need to get a professional to log into your system to
help you out. You should watch what they do, and this is the easiest way
I know.

I needed to get someone from a hardware company to log into one of our
phone servers to help debug a problem, but I wasn't just about to give
them full carte blanche access to my server. Especially as it is behind
a firewall.

I trust these guys somewhat, I mean, if they screw up, no more customer
and hello to bad PR... but at the same time, you should always watch.

So, I went hunting around, and Screen is the best answer.

Get them to log into your system and type:

``` sh
$ screen -S support
```

Then, from your shell:

``` sh
$ screen -x support
```

And bam, you are both sharing the same screen.

Nice and simple.

Of course, this isn't fool proof, and it only really lets you follow
what the other guy is doing. But it is a hell of a lot better than
sitting there blind listening on the phone to a few hundred key strokes
wondering 'what is he up to?'

blogLater

Mikel
