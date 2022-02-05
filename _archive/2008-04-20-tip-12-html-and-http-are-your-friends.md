---
title: "Tip #12 - HTML and HTTP are Your Friends"
author: Mikel Lindsaar
date: 2008-04-20
layout: post
redirect_from:
  - /2008/4/20/tip-12-html-and-http-are-your-friends
---
What is an \<em&gt; tag? How do you manually make a select box? What
about a multi value select box? Do you know the difference between a
\<submit&gt; tag and a \<button&gt; tag? Can you hand code a form to
make a restful post to one of your Rails controllers? If you can't do
all the above with plain HTML and no rails helpers or don't know the
difference between a GET and POST request and when you use either, then
you need to read on. If you can, feel free to skip to the next section.

This is part of my 8-Part tip-a-thon on the [Must Know Facets of Ruby on
Rails](https://lindsaar.net/2008/4/17/tip-8-how-learn-ruby-on-rails).
If you haven't already, please read the first part and then come forward
(there is a link at the bottom of each article that links to the next)

#### Learn All About HTML

You would think it would go without saying, but to do Ruby on Rails, you
are GOING to need to know what the old workhorse, HTML, is and how to
use it.

HTML is what we use for everything on the web. Unless you are not coding
for the web and making an entirely resourceful application that only
talks via XML or some other protocol, you will need to understand HTML.
After all, it is the presentation layer and with a bad, unusable,
unintuitive design, it doesn't matter how good your application is, your
users won't use it.

Lets give some examples.

You all know Rails has a form helper. This thing is a god-send. It turns
making an entire, fully functioning post request into:

``` ruby
<%- form_for @user -%>
```

But unless you know what that tag is actually generating, you will
always go over that and look at it and glibly say "Oh, yeah, that makes
the user form" and then when something about it doesn't work, you are in
trouble.

What about the select tag? Rails again to the rescue:

``` ruby
<%= collection_select @person, :job, @jobs, :id, :name -%>
```

And **TADA**, you suddenly have a complete select box with all the jobs
a person can have with their existing job already selected.

This is all good until you need to go outside the square, then your
underlying knowledge of how all the HTML works (or lack of it) will come
up and bite you from behind.

So how do you get around this?

Well, believe it or not, your web browser 'show source' function is a
VERY good start. Make a form and then open up the browser and have a
look at the generated code. Then even go as far as not using the helpers
and manually type the HTML code into the view and observe that it

**gasp** still looks and works the same as using the helper?

Too many times in forums and online, I have seen people (and myself too)
try to shoe horn a helper into doing exactly what they want, instead of
just coding it in HTML and being done with it (or making their own
helper).

There are many advantages with the Rails helpers, especially with
regards to code maintainability, and that is, if you use helpers you are
agreeing to code in a certain manner that will allow yourself and others
to read your code much more easily in the future. But at the end of the
day, the most important thing is providing a robust and sound product to
exchange with your users. If you can't do this, then why bother?

A great website on all the HTML tags is the [w3 schools
forums](http://www.w3schools.com/). I highly recommend going through
this site and reading up on every tag. For example, did you know that
all your efforts to try and style that submit button would be handled by
using a [button
tag](http://particletree.com/features/rediscovering-the-button-element/),
or that select boxes are not that hard to do by hand when you have to?

Also, you need to get a grip about how HTTP works. Understanding what
the differences between a GET and POST request, and why would you use
each in what scenario is critical to understanding how your rails app
works and really throws you if you try to learn anything about RESTful
interfaces.

In a nutshell (ignorning anything about REST for now that just builds on
top of this), there are two ways most browsers will accept a form sent
to them from a web browser. They are called GET and POST. You use GET
when you are retrieving something from a application and are not trying
to make any changes. You use POST when you are submitting some data to
make changes. So a query form (asking the application about something)
would usually be a GET request and creating a new user (sending data to
the application) would be a POST request.

If you don't get this, then trying to understand why a CREATE action
uses a POST and a SHOW action uses GET would be unintuitive. But with
the above single paragraph it becomes quite clear. (I'll go into RESTful
methods in a later post). Here is a good write up about [GET and
POST](http://www.cs.tut.fi/~jkorpela/forms/methods.html). Just one
point, it clears up the word 'idempotent' about 8 paragraphs in (it
basically means, "doesn't make any change on the server").

As for HTTP, that is what your Apache Web Server, Mongrel server or
mod-rails application are handling. This is the give and take between
browsers and their servers. It would do you well to understand how this
works.

The bottom line is the HTTP and the HTML you and I use ALL DAY to get
our Rails sites up and running is important and a foundation to
understanding everything else in Ruby on Rails. Honestly, if you don't
get HTML, you will NOT get Rails, you might be able to punch out a
website only using helpers, and if you can, good on you, but if
something breaks at 2am and you have to fix it, I am sure you will wish
you spent a few hours looking over how that form tag really works.

blogLater

Mikel

