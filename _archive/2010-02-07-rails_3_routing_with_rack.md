---
title: "Rails 3 Routing with Rack "
author: Mikel Lindsaar
date: 2010-02-07
layout: post
redirect_from:
  - /2010/2/7/rails_3_routing_with_rack
---
You probably all have heard that "Rails lets you route to Rack
applications directly" and thought "Oh really?" well... bet you didn't
think it would be this simple.

Rails 3 really opens up a whole new world of pluggable awesomeness. This
post expects you have already installed Rails 3 ---prerelease, if not,
follow the instructions in the [Release
Notes](http://guides.rails.info/3_0_release_notes.html)

The goal here is to make a [Sinatra app](http://www.sinatrarb.com/) run
inside of Rails, taking routes it needs directly using the new Rails
routing features.

Code is better at talking than me, so first make a new app:

``` shell
$ rails app
```

Let rails do its thing. Then we want to make a simple Sinatra app, let's
make it marginally useful and have it hit Twitter.

Make a directory `lib/twitter` and in there make a new file called
`twitter_app.rb`, inside of it put:

``` ruby
class TwitterApp < Sinatra::Base
  set :root, File.dirname(__FILE__)

  get '/twitter' do
    @user = 'raasdnil'
    t = Twitter::Search.new(@user).fetch
    @tweets = t.results
    erb :twitter
  end

end
```

This is a basic Sinatra app, it first sets its root directory to be the
directory of the current file (needed because using the Rails root will
not work) and then responds to one url `/twitter` that uses the Twitter
gem to do the heavy lifting on searching for all the tweets by some
weirdo (me).

It then assigns all the tweets to an instance variable and renders the
template `twitter.erb`.

We have to make this template, so create another folder
`lib/twitter/views` and make a file in there called `twitter.erb` and
put in the following:

``` html
<!DOCTYPE html>
<html lang="en">
  <head>
    <title>Tweets mentioning <%= @user %></title>
  </head>
  <style type="text/css" media="screen">
    div.tweet { border: 1px solid gray;
                height: 50px;
                width: 600px;
                padding: 5px;
                margin-bottom: 10px; }
    img.icon { float: left; padding-right: 10px; }
    div.text { font-family: verdana, sans-serif; }
    div.<%= @user %> { background: #F4F4FF; }
  </style>
  <body>
    <% @tweets.each do |tweet| %>
    <div class="tweet  <%= tweet.from_user %>" id="<%= tweet.id %>">
      <img class="icon" src="<%= tweet.profile_image_url %>" />
      <div class="text" >
        <%= tweet.text %>
      </div>
    </div>
    <% end %>
  </body>
</html>
```

OK, our Sinatra app is ready to fire. Now hooking it up is simple.

First, we need to make sure we require the needed gems, so open up your
`Gemfile` in Rails root and add the following:

``` ruby
## Bundle the gems you use:
gem "sinatra", "0.9.2"
gem "twitter", "0.8.3"
```

Then do a bundle check to make sure we have the gems we need:

``` shell
$ bundle check
The Gemfile's dependencies are satisfied
```

All good (if that gave you an error, just run `bundle install`).

Now the final step is to wire up the Rails Router.

Open up `config/routes.rb` and add a require for your twitter app as
well as a route to match `'/twitter'` and send to your Sinatra App,
something like this:

``` ruby
require 'twitter/twitter_app'

RackTest::Application.routes.draw do |map|

  match '/twitter', :to => TwitterApp

end
```

And that's it!

Fire up your Rails app with `rails s` as you normally would, and browse
to <http://127.0.0.1:3000/twitter> and proove it to yourself... this
stuff works.

Almost too simple.

blogLater

Mikel

