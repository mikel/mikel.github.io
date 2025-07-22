---
title: "Getting Heroku, memcached and Rails 3 working"
author: Mikel Lindsaar
date: 2010-09-13
layout: home
redirect_from:
  - /2010/9/13/getting-heroku-memcached-and-rails3-working
---
The docs for Heroku and memecached do not cover Rails 3. So here is the
short version:

In your Gemfile:

``` ruby
group :production do
  gem "memcache-client"
  gem 'memcached-northscale', :require => 'memcached'
end
```

In your environment.rb:

``` ruby
config.cache_store = :mem_cache_store, Memcached::Rails.new
```

Told you it was short.

Oh, and remember to install the memcached add on to your app:

``` shell
heroku addons:add memcache:5mb
```

Told you it was short.

blogLater

Mikel
