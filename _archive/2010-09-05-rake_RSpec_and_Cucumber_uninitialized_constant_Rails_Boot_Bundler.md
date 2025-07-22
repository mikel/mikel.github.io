---
title: "rake RSpec & Cucumber uninitialized constant Rails::Boot::Bundler"
author: Mikel Lindsaar
date: 2010-09-05
layout: home
redirect_from:
  - /2010/9/5/rake_RSpec_and_Cucumber_uninitialized_constant_Rails_Boot_Bundler
  - /2010/8/29/rake_RSpec_and_Cucumber_uninitialized_constant_Rails_Boot_Bundler
---
You might run into this problem if you are bringing a Rails 2.3 app onto
Bundler, specifically, when you try and run "rake cucumber" or just
"rake" for RSpec you get an error about
`uninitialized constant Rails::Boot::Bundler`.

The situation is most likely that (like me) you put the
preinitializer.rb file into the `config/initializers` directory instead
of just in the `config/` directory.

So double check the location as per the [bundler
guide](http://gembundler.com/rails23.html)

blogLater

Mikel
