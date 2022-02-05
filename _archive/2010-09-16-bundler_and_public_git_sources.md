---
title: "Bundler and Public Git Sources "
author: Mikel Lindsaar
date: 2010-09-16
layout: post
redirect_from:
  - /2010/9/16/bundler_and_public_git_sources
---
If you have a public git source in your production Gemfile, then you are
doing it wrong.

Bundler rocks. It lets us point our Gemfile source at almost anything, a
path, a git source and of course RubyGems.org.

But if you are using production code, and you have something like this
in it:

``` ruby
gem "mail", :git => 'git://github.com/mikel/mail.git'
```

Then you are most likely doing it wrong.

Why? Well, you have no guarantee that I will keep that repository
around. I (or any github user) could just deleted it tomorrow. And then
your deploy is broken.

Not only that, the reason you are pointing to a git source is because
there is some production critical feature that you need from the git
source. Otherwise, you would just be specifying the gem version in your
Gemfile.

So this is a recipe for disaster.

I recently took over a project (Rails 2.2.2) that had over 13 gems
specified in the environment.rb file using the Rails 2.x style
`config.gem` commands that were pointing to explicit gems inside of
Github. My first action was to go in and Fork those gems into the
client's public git repository and depend on THOSE versions, ones that
are under our control.

Of course, the next step is to go through and remove any git dependency
from the Gemfile, one by one and just revert to normal gems from
somewhere like RubyGems. But this has to be done incrementally and will
happen over the coming weeks.

So, go through your production code, and if you are pointing at someone
else's github tree, just go in and fork it and point at your own. It is
cheap insurance.

blogLater

Mikel

