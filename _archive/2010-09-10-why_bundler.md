---
title: "Why Bundler?"
author: Mikel Lindsaar
date: 2010-09-10
layout: post
redirect_from:
  - /2010/9/10/why_bundler
---
I have moved all of my Rails applications, and every client application
I am consulting for over to Bundler and using Gemfiles, and you should
too.

All of my Rails 3 AND Rails 2.x applications are now running on Bundler.
Even a Rails 2.1 app that we are in the process of upgrading is running
on Bundler, or at least using bundler for dependency management and
configuration.

Bundler is NOT some "Rails 3 thing" and if you have this misconception,
it is time you wrapped that up into a [small scruntchy ball and tossed
it](http://www.youtube.com/watch?v=OdAzdBeqPmY) into the circular file.

But some people try to install Bundler and report back to me "It's too
hard" or "It doesn't work" and "It broke my app". Of course, in many
cases, you have to configure your code correctly, but the [GemBundler
site](http://gembundler.com/) is full of information to do that.

But once your application or ruby code is configured to use Bundler, the
crazy thing is that about 9 times out of 10, any further problems is
because Bundler has found a problem with your gem dependencies that you
didn't even know you had.

I have had many many people talk to me about Bundler, in good and bad
ways, and usually, any negative comments come from a lack of
understanding on why bundler, and why it is needed.

Luckily, Yehuda was recently at EuRuKo in Karkow, and did this talk on
[Why Bundler?](http://vimeo.com/12614072) If you haven't watched it yet,
it is very well worth your time to sit through. Many things will become
clear.

Oh, and a parting tip, if you are trying to get Rails 2.1 running with
bundler, just configure bundler as if it was not a Rails Framework app.
Treat it like the Sinatra app examples on the Gembundler website.

blogLater

Mikel

