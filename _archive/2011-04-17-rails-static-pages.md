---
title: "Rails Static Pages"
author: Mikel Lindsaar
date: 2011-04-17
layout: post
redirect_from:
  - /2011/4/17/rails-static-pages
  - /2011/4/18/rails-static-pages
---
Static pages are one of those things that you have to get around to
doing for every website. This is how we implemented them on
[StillAlive](http://stillalive.com/) to make them maintainable and also
cacheable.

On pretty much every website, you will have a bunch of pages that are
just plain old static content. Good examples of these are Privacy
Policies, Terms of Use, Contact Pages and the like. These generally
contain content that rarely changes.

To make these simple static pages, we first add a catch all route at the
bottom of `config/routes.rb` which looks like this:

``` ruby
  match ':page_name' => 'site/pages#show'
```

As this is a catchall route, you need to put this right at the bottom of
your routes file. Basically it just catches anything that is not defined
in the above routes and send it off to `PagesController#show` with the
`params[:page_name]` set to the requested path.

So if the user navigates to <http://stillalive.com/plans_and_pricing>
then the `PagesController` will have the `show` method called with
`plans_and_pricing` set as the `params[:page_name]`

With the routing set, we then make a Pages controller that looks like
this:

``` ruby
class PagesController < ApplicationController

  layout 'site'

  def show
    @page_name = params[:page_name].to_s.gsub(/\W/,'')
  end

end
```

Some key points here, firstly, we set the `@page_name` variable to be
the value of the `params[:page_name]`, call `#to_s` on this (which
handles the case of `params[:page_name]` being `nil`) and then call
`#gsub` on the string stripping out anything that is not a word
character.

With that done, we then drop through to rendering `pages/show.html.erb`
which looks like this:

``` html
<%= cache "site-page-#{@page_name}-#{App.git_revision}" do %>
  <%= render :partial => @page_name %>
<% end %>
```

So this just renders the partial with the page name requested.

So in the example above, we have a partial called
`pages/_plans_and_pricing.html.erb` that gets rendered.

We also wrap it in a cache block. The cache block includes the page
name, and also our git revision. We set the git revision so that every
time we push new code to our server, all the prior cached pages get
expired. This provides a no brainer way to make sure the latest code is
showing on the site.

The `App.git_revision` call is using the [App Config
gem](http://rubygems.org/gems/app) and is set by modifying
`config/app.rb` to look like this:

``` ruby
class App < Configurable # :nodoc:
  # Settings in config/app/* take precedence over those specified here.
  config.name = Rails.application.class.parent.name

  config.git_revision = `git rev-parse HEAD 2>/dev/null`.to_s.strip
end
```

This sets the value git_revision on boot. Simple.

Now the above code is good, but what happens when someone requests a
page that does not exist on our site, we'll, we can't handle this the
simple way, as the MissingTemplate exception gets raised outside of our
controller, inside the show view.

One solution would be to wrap the `render :partial` call in the
`show.html.erb` template in a rescue block, rescue the
`ActionController::MissingTemplate` exception and render a missing
template instead, however, the problem with this is that the response
code will still be 200 OK, where we really want it to return a 404 page
not found status.

So we need a way to check to see if the partial is valid or not, before
we render the show action. There is no simple way to do this, so the way
we handle it is by creating a `partial_exists?` method in the controller
which checks, like so:

``` ruby
class PagesController < ApplicationController

  layout 'site'

  def show
    @page_name = params[:page_name].to_s.gsub(/\W/,'')
    unless partial_exists?(@page_name)
      render 'missing', :status => 404
    end
  end

  private

  def partial_exists?(partial)
    ValidPartials.include?(partial)
  end

  def self.find_partials
    Dir.glob(Rails.root.join('app', 'views', 'site', 'pages', '_*.erb')).map do |file|
      file = Pathname.new(file).basename.to_s
      # Strip leading _ and then everything from the first . to the end of the name
      file.sub(/^_/, '').sub(/\..+$/, '')
    end
  end

  # Do this once on boot
  ValidPartials = Site::PagesController.find_partials

end
```

By using a constant at the bottom, we only run the `Dir.glob` once at
boot time to reduce the overhead (instead of running it on every
request). The `find_partials` method returns a list of partials that
look like:

``` ruby
['about', 'plans_and_pricing', 'privacy_policy'...]
```

This way, every time we restart our server, we get a new list of
partials in production mode, and every time we refresh in development
mode, this list gets updated in any case.

Hope this helps :)

blogLater

Mikel

