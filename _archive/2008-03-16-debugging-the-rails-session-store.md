---
title: "Debugging the Rails Session Store"
author: Mikel Lindsaar
date: 2008-03-16
layout: home
redirect_from:
  - /2008/3/16/debugging-the-rails-session-store
---
The Ruby on Rails session is a dark and mysterious lady who is with you
ever step of your applications development way... Usually she goes about
doing her business without any problems, but sometimes things go awry...
and hell hath no fury like a session scorned...

So sometimes you just need to know what is going on with your session
store in Rails, what variables are being stored and what variables you
can call from your server, luckily, looking into the session is easy.

I recently answered this question on Ruby on Rails Talk mailing list,
however, that solution put the session into the view, and while this
works, it is a quick and nasty solution that doesn't scale and leaves
you open to accidently leaving that session data IN the view if you
forget it's there (unlikely I know, but in any case, using the view to
debug the session is a bad code smell).

So, the other solution, is put it into your development log - where it
belongs really.

That way you can contain the session tantrums to your development.log
file which is just a quick and easy rm log/development.log away from
silencing them for ever...

Hmm, if only the tantrums at home were that easy to handle...

ANYWAY!

The process is simple enough, make a method in your application.rb that
looks like this:

``` ruby
class ApplicationController < ActionController::Base

  def log_session
    logger.debug("\nSession before action:\n\n#{session.to_yaml}")
    yield
    logger.debug("\nSession after action:\n\n#{session.to_yaml}")
  end

end
```

And then, in any controller that you want to debug, put the following:

``` ruby
class UsersController < ApplicationController

  around_filter :log_session unless RAILS_ENV == 'production'

end
```

This will then log your entire session to development.log in a nice YAML
format, then execute your controller code and then log your session
again after your controller code executes.

The "unless RAILS_ENV == 'production'" just avoids calling this filter
in production mode.

If you want to dump your session into the view, like I suggested on the
mailing list, you can use:

``` html
<pre>
  <%= session.to_yaml %>

```</pre>
```
```

In your view to output it in YAML format.

blogLater

Mikel
