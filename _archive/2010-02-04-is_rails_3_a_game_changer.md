---
title: "Is Rails 3.0 a Game Changer? "
author: Mikel Lindsaar
date: 2010-02-04
layout: home
redirect_from:
  - /2010/2/4/is_rails_3_a_game_changer
---
With Rails 3 on its way to release, and all it is bringing in terms of
features and refactorization, some might be wondering, is it a "game
changer"?

Well, the simple answer to that is, "Who cares?"

The important question is not "will Rails 3 revolutionise the web
development industry?" but a much more pragmatic one of "what does Rails
3 offer that will help me?".

Or more importantly "Will upgrading my site to Rails 3 be worth it!?"

And I feel the honest answer to that last question is - yes.

But here is the pinch, the benefit you and your site will gain from
upgrading will not be realised from the improvements in the latest way
to validate a model, or the new query syntax, because, let's be real
here, if you are upgrading, then whatever you have right now is most
likely working, so even though Rails 3 gives you another three or four
ways to skin the problem, the problem will just be skinned as it was
before, regardless of elegance.

Sure there are gains to be had from cleaning up horrid old find methods
and migrating to a chain-able relation syntax. Or cleaner, more usable,
mailers from the new ActionMailer syntax. But all of these are marginal
improvements, they help, sure, but for an existing operational site,
don't give a huge amount of benefit.

The real benefit I think your site will gain from Rails 3 comes down to
just three killer features; HTML 5, Modularity and speed.

Let me explain myself here before you all go
[OMGWTFKTHXBAI![](?)](http://github.com/rails/rails/commit/2ebea1c02d10e0fea26bd98d297a8f4d41dc1aff#comments)

### HTML 5

HTML 5 is the new black.

There, I've said it.

There are lots of ideas but nothing really concrete on how HTML 5 is
going to change the web screen-scape, there is definitely movement at
the station, but the word is not quite around yet and there are still a
lot of people still looking at each other going "hmmm".

The latest release from Apple show them positioning their products to
take full advantage of HTML 5, and a lot can be done with this new
standard, it may well become the flash killer many people are hoping.

The real exciting thing about HTML 5 though is its capabilities in the
mobile device world. HTML 5 and mobile devices are made for each other,
literally, and this works NOW. It's not something that might work when
the browsers get around to it, it is a feature that you can leverage
instantly.

For us Rails developers, the cool thing is v3 has now moved in this
direction. With its HTML 5 support now baked into Action Pack helpers
and a HTML 5 viewpoint on how to present web pages, it is gearing up for
the future, whatever that may be.

Getting your app updated to version 3 will not suddenly make the sky
open up with the HTML 5 Gods shining down at you and driving more
traffic at your site, but it will place you in a very good position to
take advantage, quickly, of whatever will happen, and leverage the
mobile market like never before.

### Modularity

Rails 3 provides a modular framework that is, wait for it,

**extensible**. All of the internals in Rails received a massive clean
out turning them into, essentially, the same type of object as any other
Rails plugin. Calling Action Mailer or Active Record "plugins", isn't
really fair considering how functional they are, but really, when you
get down to it, that's all they are. They are just parts of the Rails
framework, that can be **swapped out** with other plugins.

You have already seen alternatives for Active Record (Datamapper,
Sequel, Mongomapper et al) but traditionally, getting these sorts of
plugins working in Rails has been a sparring match with Action Pack and
this pain was the motivation behind creating Active Model, the first
step on modularising the Rails framework.

But think about it for a second, with a complete Plugin API, documented,
showing all the hooks, features and methods your new plugin can take
advantage of, and with that API having full, defined access to the
entire Rails stack from boot to shutdown, your opportunities to create
or take advantage of something incredible in this space have just
increased several thousand fold.

Want to make a killer admin interface? Want to create a "plug in" blog?
Need a forum feature in your Rails app? You now have defined tools to
make that happen.

And **that** is reason enough to upgrade to Rails 3. If your app is not
on Rails 3, you can't take advantage of the community of functionality
that is going to grow up around this platform as we move forward
documenting and establishing this community.

But if you are already on Rails 3, and someone releases a new gem that
provides you a new and amazing way to zig when everyone else is zagging,
then, you will be in a position to implement rapidly.

### Speed

I am not talking about how fast a Rails app can serve up a page of HTML
here, although, Rails has had a ton of improvements in that area, I am
talking about how fast you and your application can react to the changes
occurring on the web today.

HTML 5 support and Modularity bring you agility and speed. You will be
able to react to a changing web rapidly, and being able to move fast
without baggage holding you down translates into \$\$ in your pocket.

Now that I have written the above, don't get me wrong, I am not
downplaying the massive amount of work done to improve Rails as a
framework, and I am developing an application on Rails 3 right now that
has been an absolute dream compared with developing on Rails 2.x.

But I do think, at the end of all this, you too should be able to answer
the question of "Will upgrading my site to Rails 3 be worth it!?" with
just one word.

Yes.

blogLater

Mikel
