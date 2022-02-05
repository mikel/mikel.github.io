---
title: "Bundle Me Some Sanity"
author: Mikel Lindsaar
date: 2010-04-01
layout: post
redirect_from:
  - /2010/4/1/bundle_me_some_sanity
  - /2010/3/31/bundle_me_some_sanity
---
You know, there are these two guys working in broad daylight on Bundler,
[Yehuda](http://yehudakatz.com/) and [Carl](http://carllerche.com/)
(he's the one in the sidecar), but I don't think people have really
grasped the importance of what they are doing.

Bundler is just as mind blowing a development for Rails 3 as any other
change in the Rails framework. As the
[wycats](http://twitter.com/wycats) states; `<strong>`{=html}"Bundler
manages an application's dependencies through it's entire life across
many machines systematically and repeatably"`</strong>`{=html}.

To me, bundler takes the guess work out of dependency management, it
simply provides you with a way to know what gems you are distributing
with your application, we (as a Ruby community) have never had such a
comprehensive solution to gem management before.

But like any new tool, it is going to go through some growing pains. To
my surprise, (and the credit of the authors) the growing pains have been
short and sharp, rapidly fixed as bundler grows to whole new levels of
reliability.

And also like any new tool, it is optimised for certain environments, in
bundler's case, [USE RVM!](http://rvm.beginrescueend.com/) If you are
not using RVM and you are running multiple rubies with Bundler,
honestly, you're mad. Do yourself a favour, download RVM and use it. You
can then specify sand boxes of gem sets for each ruby or application you
have, goodbye incompatible gems conflicting with each other.

To give you a taste of just how awesome the Bundle RVM marriage is,
check this out:

After you install RVM, go into the directory of each app you want to
have their own private gem sets and create a file called
`<span class="shell">`{=html}.rvmrc`</span>`{=html} and put in there:

``` shell
rvm ruby-1.8.7@railsplugins
```

Which is what I have on my RailsPlugins.org repository.

Then change into the directory, and RVM will tell you it doesn't know
about the gemset:

``` shell
$ cd railsplugins
Gemset 'railsplugins' does not exist, rvm gemset create 'railsplugins' first.
```

OK, so go ahead and create the gemset and have a look at what gems you
have installed:

``` shell
$ rvm gemset create 'railsplugins'
Gemset 'railsplugins' created.
$ gem list

*** LOCAL GEMS ***

$ ruby -v
ruby 1.8.7 (2010-01-10 patchlevel 249) [i686-darwin10.2.0]
```

Good... see? A clean ruby 1.8.7, as if you just bought the computer.

Now go ahead and install bundler for this clean gemset:

``` shell
$ gem install --no-rdoc --no-ri bundler
Successfully installed bundler-0.9.14
1 gem installed
```

Cool, now all that we have left is to give bundler the reins and tell it
to do what it does best:

``` shell
$ bundle install
<lots of output>
```

Now when you gem list for that directory you will get all the gems in
your gem file, and when you move to a different directory (with a
different .rvmrc) all your gems get magically switched out for the new
set.

Honestly, with the number of different clients I am coding for and the
number of libraries I am working on, I can't imagine being any where
near as productive without the RVM and bundler team.

Yehuda has made a fairly comprehensive guide to bundler at the [Gem
Bundler](http://gembundler.com/index.html) site which you should read
through and understand, and I have only brushed the surface of RVM, you
should check it out as well at the [RVM
site](http://rvm.beginrescueend.com/)

blogLater

Mikel

