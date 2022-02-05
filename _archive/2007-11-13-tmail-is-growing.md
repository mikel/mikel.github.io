---
title: "TMail Is Growing"
author: Mikel Lindsaar
date: 2007-11-13
layout: post
redirect_from:
  - /2007/11/13/tmail-is-growing
---
TMail is the mail library that powers ActionMailer in Ruby on Rails and
the mail component of Nitro... and it is alive!

Recently, I was working on a bug I found in TMail.

Being opensource, I decided to download the source and scratch my own
itch.

I found my problem, wrote a patch and submitted it.

It turns out though that Mr Aoki, who authored the code, could not
continue. After some emails, I have taken on handling the TMail source
code with a guy called Trans.

So you can now see the [TMail project](http://tmail.rubyforge.org/) and
submit bug and feature requests.

The first thing we did was clean up the code a bit, apply my patches,
make the website and release TMail as a gem which installs on basically
anything.

We also have submitted and had approved changes to the Nitro and Ruby on
Rails source tree, so in the next versions of these products you get the
latest and greates TMail installed.

Additionally, Nitro now uses the Gem TMail instead of bundling it's own.
So you can update TMail separately to Nitro.

And as of a recent ticket on the rails dev site, Rails' ActionMailer
will now use the gem version of TMail if it detects that you have a
newer version installed than 1.1.0.

This means as we fix things in TMail, all you Rails and Nitro freaks out
there are a gem update tmail away from having all the patches and fixed.

Pretty cool huh?

Anyway, I really would like anyone to post up bugs and patches and fixes
for TMail on the ruby forge page. My main focus is getting the existing
stuff working and then cleaning up the documentation of TMail a lot.

Let me know if you have anything you need or want!

blogLater

Mikel

