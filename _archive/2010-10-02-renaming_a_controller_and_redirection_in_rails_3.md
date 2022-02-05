---
title: "Renaming a controller and redirection in Rails 3"
author: Mikel Lindsaar
date: 2010-10-02
layout: post
redirect_from:
  - /2010/10/2/renaming_a_controller_and_redirection_in_rails_3
  - /2010/9/30/renaming_a_controller_and_redirection_in_rails_3
---
I had the situation where I wanted to rename a basic part of the
[TellThemWhen](http://tellthemwhen.com/) website, that is, changing the
name of "instants" to "notifications". As this was a major part of the
whole website, I had to make sure existing URLs still resolved
correctly, luckily in Rails 3, this couldn't be simpler!

This was a fairly big issue, "Instants" were the name of the basic
product of the site, that is, you could make an "instant" to share with
other people. After a lot of varied feedback however, we decided that
"notification" was a better name.

But all the URLs our clients have been distributing look like
http://tellthemwhen.com/instants/a3s2... and people have been landing on
our [new instant page](http://tellthemwhen.com/instants/new) directly
per our analytics data.

So I needed a solution which basically remapped `/instants/ANYTHING` to
`/notifications/ANYTHING`. Happily, the Rails 3 router solves this.

First step is to make a redirector. This is a really simple rack app, I
made mine like so and just put it at the top of my `config/routes.rb`
file, it looks like this:

``` ruby
module TellThemWhen
  class InstantRedirector
    def self.call(env)
      destination  = "#{env['PATH_INFO']}".sub('instant', 'notification')
      destination << "?#{env['QUERY_STRING']}" unless env['QUERY_STRING'].empty?
      [301, {'Location' => destination}, ['Instants are now called notifications']] 
    end
  end
end

TellThemWhen::Application.routes.draw do
  # ...
end
```

This is a simple Rack application. It has a class method called "call"
that the current environment as an attribute, then pulls the path data
substituting the first occurrence of "instant" with "notification", then
adds all of the params data on the end, and sends back a 301 redirect to
the client with this new URL

Then in the `routes.rb` I have:

``` ruby
TellThemWhen::Application.routes.draw do
  # ...
  # Catch old instant style URL and redirect to Notifications
  match '(/my)/instant(s)(/:id)' => TellThemWhen::InstantRedirector
end
```

Here I need to match both "/my/instant" and "/instant" as well as the
plural form of instants, I also want to be sure I am only matching the
URLs that have instant directly off the root, just in case in the future
I have a URL that looks like "/notification/instant".

Using the parentheses around `(/my)` and `(s)` and `(/:id)` make these
optional to the match process.

This match statement simply calls the rack app, InstantRedirector which
then runs the `call` class method, returning the redirection array
sending the user back to the correct notifications path with a 301
permanent redirect.

Sweet.

blogLater

Mikel

