---
title: "New Rails Version 3.0 Guides Online"
author: Mikel Lindsaar
date: 2010-01-28
layout: home
redirect_from:
  - /2010/1/28/new-rails-version-3-guides-online
  - /2010/1/29/new-rails-version-3-guides-online
---
I am going through and updating a lot of the guides for Rails. As I do
each one, I will update this post.

Rails 3 has a *lot* of changes. Don't be fooled, the core team has been
hard at work for the last year ever since the
[Merb](http://yehudakatz.com/2008/12/23/rails-and-merb-merge/) and
[Rails](http://weblog.rubyonrails.org/2008/12/23/merb-gets-merged-into-rails-3)
announcement.

You can think of Rails 3 as a massive refactoring and extraction
project. The amount of spring cleaning is, to put it bluntly,
phenomenal.

So as I go through each guide and update it, and it gets published, I'll
link to it here, so you can all follow along :) I would also like all
the feed back in can get on these. You can email me, send me a tweet or
comment here.

### Getting Started with Rails

[Getting started with
Rails](http://guides.rails.info/getting_started.html) was,
appropriately, the first guide that was updated. This was different
enough that the version 2 guide simply did not work on Rails 3. You can
also find all the code for the getting started guide at my [Getting
Started Code](http://github.com/mikel/getting-started-code) github
repository.

### Layouts and Rendering in Rails

[Layouts and Rendering in
Rails](http://guides.rails.info/layouts_and_rendering.html) was the next
guide updated. Again, a lot of changes in Rails 3, highlights on the
HTML 5 implementation, handling of the new
`<span class="fixed">`{=html}video_tag`</span>`{=html} and
`<span class="fixed">`{=html}audio_tag`</span>`{=html} helper methods
and a big gotcha on partial rendering (you'll have to read the guide for
all the juicy bits, but enough to say that a lot *LESS* local variables
get magically defined in partials now.

### Next Up

I am mid way the Action Mailer guide now that the code has been updated
to the new API. Check back soon.

blogLater

Mikel
