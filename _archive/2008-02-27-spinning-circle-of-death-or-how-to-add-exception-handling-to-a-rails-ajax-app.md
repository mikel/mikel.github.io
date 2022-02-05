---
title: "Spinning Circle of Death - Or How to Add Exception Handling to a Rails AJAX App"
author: Mikel Lindsaar
date: 2008-02-27
layout: post
redirect_from:
  - /2008/2/27/spinning-circle-of-death-or-how-to-add-exception-handling-to-a-rails-ajax-app
---
If you are programming a Ruby on Rails AJAX application, you will have
to handle system exceptions at some point, because if you don't, the
user gets to sit watching a spinner.gif file merrily spinning away for
the rest of his or her natural existence...

The first option is to handle every link, form and submit to remote with
a failure callback... Basically, when you do an AJAX request in Rails,
and you use one of the helpers, you can use call backs like this:

``` ruby
<%= link_to_remote "Create New Task", 
                    :url => new_tasks_path,
                    :loading => %[$('MainSpinner').show();],
                    :success => %[$('MainSpinner').show();],
                    :failure => %[...do some javascript here...] -%>
```

But the idea of going through *every* webpage to find the above calls
and enter *every* callback did not really excite me, besides, my fingers
recently joined a workers union and they were already looking at their
terms and conditions clauses just waiting for me to try and inflict them
with repetitive strain injury work practices!

Luckily there is a handling that you can do globally. Make your
ApplicationController class override the rescue_action_in_public method
and implement a custom javascript handling. What you want to do here
though is to make an AJAX call back to the page the user was looking at
and update some part of the page with the error message.

First we need an "ErrorBox" div in the application layout file for us to
update with the error message, so:

``` html
# /app/views/layouts/application.rhtml
...
<body>
  <div id="ErrorBox">

  </div>

  <%= yield -%>

</body>
```

And now, the code in ApplicationController to update the error box:

``` ruby
# /app/controllers/application.rb

  protected

  def rescue_action_in_public(exception)
    respond_to do |wants|
      wants.html { super(exception) }
      wants.js   { render :update do |page|
                     error = "There was an error..."
                     page.replace_html('ErrorBox', error)
                   end }
    end
  end
```

So now, when you hit the exception in your code, the
ApplicationController goes to rescue_action_in_public, if it is HTML, it
passes the error on to be handled as normal with the "we're sorry,
something went wrong" message, if the request is an AJAX request, it
does an AJAX page update and updates the ErrorBox div with the error
message.

The cool thing about this is it is free... once you implement this,
EVERY page on your site and EVERY link/form/submit to remote you make,
will have this basic error handling.

blogLater

Mikel

