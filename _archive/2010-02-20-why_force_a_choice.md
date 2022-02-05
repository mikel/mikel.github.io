---
title: "Why Force a Choice? "
author: Mikel Lindsaar
date: 2010-02-20
layout: post
redirect_from:
  - /2010/2/20/why_force_a_choice
---
Recently I have been reading a bit from the Python crowd, and I realised
a key point on why Rails is successful, you are not forced to choose.

You have all heard the "Convention over Configuration" mantra, and, if
you use Rails, you most likely subscribe to this war cry, and why not?
It enables the average developer to get up of the ground *fast* with an
application that works, while simultaneously allowing your non average
developer to do whatever the hell they want and extend the system in new
and interesting ways.

This mantra provides the Rails Community with probably the second
biggest advantage over any other web development framework out there,
the first advantage is of course Ruby itself.

But while reading the [installation
manual](http://djangoadvent.com/1.2/deploying-django-site-using-fastcgi/)
from our
[DeeJayAngo](http://railsenvy.com/2007/9/10/ruby-on-rails-vs-django-commercial-7)
friends, I kept hitting spots where the author was asking the reader to
make decisions, `mod_wsgi` or `mod_python`, `Apache` or `Nginx`,
`threaded` or `prefork`, the list goes on.

Now assumedly, the audience that article was written to was a crowd of
developers who do not already know how to install a Python based web
server, so asking them to make decisions on the capacity, style,
environment and resources of a web app is a bit premature.

Of course, I am making an example of that one article, but I keep seeing
this in various instruction manuals and frameworks. If that article was
entitled "Django Installation Reference for the Experienced Developer"
then fine, but it isn't.

This reminds me of a saying from my [philosophy of
choice](https://lindsaar.net/about_mikel), "To decide, one must first
understand", and this holds very true in all of our web development
circles, not just programming and installation guides.

Rails is opinionated, this is another way of saying that the developers
of Rails (who do understand) makes decisions on behalf of the new user
(who has relatively no clue) on how the system should behave. Then, step
by step the user expands their knowledge up to a point where they
understand the system themselves, and then, can make their own
decisions, like change a javascript library, or write your own style
scaffold, or whatever you choose.

But you as a Rails developer need to also keep this nugget of philosophy
in mind when you are developing your Rails app. Your new customer has no
idea how your system works, if the first thing you do is require them to
make decisions, then chances are you are going to lose customers.

Each step of your site should have, as much as possible, ONE action that
the customer should do to proceed to the next step.

Customer comes to your site for the first time, good, offer them the
trial account, obviously and clearly. They don't understand your
service, they don't really need to beyond "Will this service solve my
problem at a realistic price?". Making them decide to buy plan A or plan
B, when they don't even know what it is you do is just asking for
disaster.

Customer logs into their newly purchased account, good, tell them what
to do as a first action. Then, preferably, tell them what the second
standard action is. Of course, don't force them to do what you think is
the best next step, but these User Interface guides can drastically
improve your site's usability.

The other thing that this forces you to do as a developer is simplify
your site design and change the way you think. Of course you want the
user to have many options, but if you keep this idea in mind of "Does
the user at this point understand enough to be able to make a decision?"
then you will find your product will become more and more successful.

blogLater

Mikel

