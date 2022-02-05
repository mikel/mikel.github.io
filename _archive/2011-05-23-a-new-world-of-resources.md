---
title: "A New World of Resources"
author: Mikel Lindsaar
date: 2011-05-23
layout: post
redirect_from:
  - /2011/5/23/a-new-world-of-resources
---
Last year I attacked a long lost black sheep of the Rails family,
ActionMailer. This was because I had a project that needed to use email
and I found the current implementation, shall we say, somewhat lacking.
This year, I'm turning my attention to really the only remaining black
sheep left, ActiveResource.

ActiveResource needs to be upgraded to be a real citizen in the Rails 3
family, in fact, in the last few years there have only been very minor
fixes to ActiveResource while the rest of the world moved forward.

So what do we have? Happily, working code.

ActiveResource, as it stands now, works for the simplest of cases. If
you have a controller exposing a Rails REST based resource, and you
point ActiveResource at it, you will be able to perform the basic CRUD
operations you have come to know and love.

But if you want to go any further, you are on your own.

Associations with ActiveRecord objects don't work, validations need
attention, bulk updates and transactional support are missing entirely.
The code is really as it was when it was first released.

With the world moving towards using rich clients that hit a back end API
that abstracts the data layer, these things need to change. Having your
front end client go to delete 100 records requiring 100 requests to
complete is no fun, and a waste of time.

Sure you as a developer can dive in and create all these things. But
that is the problem. With each developer rolling their own we end up
with a mass of Rails apps that are all different, which increases the
work load for all of us. ActiveResource must provide the same level of
opinionated functionality as the rest of Rails. There needs to be a
reasonable opinion on how to provide an API, a template that you can
reasonably expect all Rails applications to follow.

The way I see it, there are two broad use cases for ActiveResource and
the code that is exposed in the controllers. Firstly we have the "bolt
on API", this is the API that is simply added to existing controller
code typically using `respond_to` and returning JSON or XML
representations of objects.

The second type though is the pure API, these are the APIs that are
built from the ground up only to talk to other systems, the API at
rubygems.org is a good example of this. It is not a patch on existing
functionality, but instead a core member of the entire application.

With the above in mind, I want to implement the following into
ActiveResource:

-   Opinionated way to produce a "pure API" with Rails (think "rails
    generate api" for Rails applications that need to expose a separate,
    formal API for rich clients)
-   Support for bulk updates of objects to existing controllers
    (show_many, change_many, update_many and destroy_many) - see idea in
    [David's Gist](https://gist.github.com/981520)
-   Transactional support for bulk operations
-   Support for multi type operations (for example, updating the post
    and the author at the same time) outlined in the Rails Conf talk by
    Yehuda Katz
-   Association support - providing connections through to local ORMs
-   Better validation handling and reliable ways to communicate error
    messages to client apps

The above is not an exhaustive list and I am interested in your
comments. If you are interested in helping, send me an email or tweet to
([\@raasdnil](http://twitter.com/raasdnil))

I'll be posting updates here and on my twitter feed as we move forward.

blogLater

Mikel

