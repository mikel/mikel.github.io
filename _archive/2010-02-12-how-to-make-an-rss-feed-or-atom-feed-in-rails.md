---
title: "How to make an RSS feed in Rails"
author: Mikel Lindsaar
date: 2010-02-12
layout: home
redirect_from:
  - /2010/2/12/how-to-make-an-rss-feed-or-atom-feed-in-rails
---
Easy. Don't. Use an ATOM feed instead. Rails is opinionated software, it
has an opinion on feeds, there is an `atom_feed` helper, but no
`rss_feed` helper? Omission? Nup.

I added the ATOM feed to [Rails Plugins](http://railsplugins.org)
website very simply, by using the Rails `atom_feed` helper. It was a
simple case of creating a `FeedsController` with just a single index
action, which collected up all the time line events that needed to go
onto the feed and assigned them to the view in an `@events` ivar.

So the controller looks like this:

``` ruby
class FeedsController < ApplicationController

  layout false

  def index
    @events = TimelineEvent.for_feed
    @title = "Rails Plugins Feed"
    @updated = @events.first.created_at unless @events.empty?
  end
end
```

Then in the view file `app/views/feeds/index.atom.builder` looks like
this:

``` ruby
atom_feed do |feed|
  feed.title(@title)

  feed.updated(@updated)

  @events.each do |event|
    feed.entry(event) do |entry|

      entry.title(h(event.title))
      entry.summary(truncate(strip_tags(event.description), :length => 100))

      entry.author do |author|
        author.name(event.author_name)
      end
    end
  end
end
```

And then the route to wire it up:

``` ruby
# config/routes.rb (Rails 2.0)
ActionController::Routing::Routes.draw do |map|
  map :resources :feeds, :only => [:index]
end
```

And finally the `auto_discovery_link_tag` in the `application.html.erb`:

``` html
<%= auto_discovery_link_tag(:atom, "/feeds.atom") %>
```

Now this was all well and good, and I thought, why not add an RSS feed
as well?

I started down on this path and the first thing that struck me was,
there was no `rss_feed` helper in Rails, why? Seemed like an
ommission...

Then I was looking around the web and found many examples on how to do
an RSS feed in Rails, but none of them mentioned this omission of the
helper, why?

I didn't puzzle over this long, and just went ahead and added an RSS
feed, it wasn't hard, you can find this out from your friend google.

But then I got this IM from [Sam Ruby](http://intertwingly.net/) after I
let him know the RSS feed for Rails Plugins was now online:

`<strong>`{=html}"Ewwwww"`</strong>`{=html}

Which was not really the answer I was expecting, so I stated:

`<strong>`{=html}"I never did get the ATOM v RSS
debate"`</strong>`{=html}

To which he replied:

`<strong>`{=html}"I started the Atom vs RSS debate."`</strong>`{=html}

And that started an interesting chat! Let me tell you!

Turns out that [ATOM](http://en.wikipedia.org/wiki/Atom_%28standard%29)
is actually defined, with [RFC
4287](http://www.ietf.org/rfc/rfc4287.txt) that covers all the basics of
what you need to know.

Also turns out that any modern reader will handle ATOM, just as easily
as RSS.

Also turns out that with ATOM you can define things like (gasp) language
settings, Internationalization, content types and several other points
which make the data a lot more consumable.

So, then I added the following to the Rails Plugins website:

``` ruby
class FeedsController < ApplicationController
  def index
    # ...
    respond_to do |wants|
      wants.rss do
        redirect_to feeds_path(:format => :atom),
                    :status=>:moved_permanently
      end
      wants.atom
    end
  end
end
```

And decided to sum up my gained knowledge with: [We are Rails, we are
opinionated, ta-ta RSS http://bit.ly/c9eyNL -
KTHXBAI](http://twitter.com/raasdnil/statuses/9045548351)

blogLater

Mikel
