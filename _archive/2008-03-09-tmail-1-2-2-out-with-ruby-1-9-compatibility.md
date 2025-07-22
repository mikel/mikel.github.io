---
title: "TMail 1.2.2 Out with Ruby 1.9 Compatibility"
author: Mikel Lindsaar
date: 2008-03-09
layout: home
redirect_from:
  - /2008/3/9/tmail-1-2-2-out-with-ruby-1-9-compatibility
---
Well, 1.2.2 is now released. You can get the latest version by gem
install tmail or download from the [TMail Rubyforge
project](http://rubyforge.org/frs/?group_id=4512&release_id=19945)

There are two big things about the latest version of TMail:

1\. Ruby 1.9 compatibility.

This really opens the door for many *other* projects to be able to be
compatible with Ruby 1.9 as a lot of people depend on TMail for their
mail delivery. I am moving some projects, myself, to 1.9 with a target
of using it at the 1.9.1 release, and this was a major step.

There were quite a few areas where the 1.9 character encoding features
meant we could do away with a lot of hacks with KCODE we were using to
get the same job done. However, because of this, there are places in the
code where we have to explicitly check for the Ruby version to switch
the program execution as the two paths are not compatible at all. Leads
to some messy code in spots, but it works well.

2\. Documentation

I personally had a hard time with the TMail documentation, I have
attacked this in my spare time and produced, I think, some easy to read
docs with a lot of examples. Hopefully this will help others get started
with email on Ruby (which is surprisingly easy by the way!).

But doing the documentation has been quite a learning experience! You
have to really pull apart your code and look at the internals of it and
understand it to see how it could work and what use cases there are for
it. I think I have learnt more about how the internals of TMail really
work by documenting it, than I ever would have by using it.

Anyway, there it is, 1.2.2, hope you enjoy it.

As always, if you find a bug, you can [do something about
it](https://lindsaar.net/2007/12/5/are-you-a-real-programmer) and
[contribute a
patch](https://lindsaar.net/2008/1/19/contributing-to-tmail), or simply
[let us know](http://rubyforge.org/tracker/?group_id=4512).

blogLater

Mikel
