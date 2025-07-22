---
title: "Are you a real programmer?"
author: Mikel Lindsaar
date: 2007-12-04
layout: home
redirect_from:
  - /2007/12/4/are-you-a-real-programmer
---
I might be biased, I might be talking from a lack of experience, but if
you are reading this and you are not involved in an open source project,
then you are not a real programmer...

No, really.

Why would I say such a thing?

Simple.

Because I wasn't (and, really, I am still trying to be).

Here is the deal. When you start programming you are working for
yourself. You are making changes to your own systems, you are designing
what you want to design and at the end of the day, you are producing
something that really, only you have to deal with.

Documenting that method doesn't really matter, deciding on what
variables a class method will take has basically no consequences beyond
a quick re-factoring.

But when you get into making an open source package (like I did with
taking over [TMail](http://tmail.rubyforge.org/) ), you suddenly have to
code with a whole NEW viewpoint.

Like "OK, this method is named just plain wrong, I want to change it.
Hmm... what would that break for someone else, would it matter, how
important is it for me to modify this".

Or "I have no #\$`#$%`#\$ idea on how to do this thing! OK... better
learn it because the problem is not going away!"

The second one was exactly how I felt when I found out that there was a
bug in the way TMail was parsing email addresses.... have you ever hear
of YACC? Me neither, well, not really, I knew it had something to do
with compilers, but TMail uses RACC for which there is basically no
documentation, as a parser compiler for it's email addresses. Very
efficient, amazingly beautiful to see working, but going from zero
experience to debugging it was a stretch and a half! And I can tell you
I am a better programmer for it.

But what do you do? You might be sitting there reading this and thinking
"OK, I have never programmed on an open source project, how do I get
involved?"

Well the good news is, it is very easy.

First, go read Dr Nic's great post about how to [write a
patch](http://drnicwilliams.com/2007/06/01/8-steps-for-fixing-other-peoples-code/).
This covers all the basics steps of checking out code, writing the patch
and sending in the email.

Then, find a software project in [Ruby forge](http://www.rubyforge.org/)
(or any other forge) that you want to contribute to. Maybe it is a
library you use a lot (that was the case with me and TMail) or maybe
something just interests you.

Then go ahead, find a problem and write the patch and send it in.

Do this once or twice and then ask the guys if you can help develop or
be part of the team (right now I would love someone to step forward who
knows anything about encoding and decoding character sets because I need
help in TMail!)

Usually, you will find on the newer projects that the admins are more
than willing to get people into the fold and help out.

You will find that writing open source software stretches you in ways
you never imagined. You will learn new things, find out about
multiplatform issues and basically, really, it gives you another avenue
to practice your skills on that might not be directly related to what
you do day to day.

It is one of the most rewarding thing to see the number of downloads of
the product you have helped create keep rising as more and more people
find out about it and use it, many of which you will never meet or know
about. But it is one of those programming warm fuzzy feelings of givings
something back to this amazing open source community.

Anyway, don't think about it, go read Dr Nic's post and go join a
project (or start one of your own!) You will not regret it.

blogLater

Mikel
