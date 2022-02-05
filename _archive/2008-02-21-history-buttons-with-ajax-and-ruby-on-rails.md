---
title: "History Buttons with AJAX and Ruby on Rails"
author: Mikel Lindsaar
date: 2008-02-21
layout: post
redirect_from:
  - /2008/2/21/history-buttons-with-ajax-and-ruby-on-rails
---
If you are using Ruby on Rails with AJAX to update parts or whole pages
of your site, you will hit the history problem soon enough, luckily,
with [Really Simple History
(RSH)](http://code.google.com/p/reallysimplehistory/) and Rails' RJS
templates and helpers, it becomes quite trivial to handle.

#### First a Quick Primer

So a normal web site (and therefore a "normal" rails site) uses many
different complete web pages sent to the client browser. Each one is
sent as a separate cycle of action and delivered to the client browser
that then reads the page and loads it up. This is one of those things
like 'rain falls' and 'the sun comes up in the east' etc...

But AJAX changes those rules. Actually, it changed those rules some
years ago... but there you go.

What you can do with an AJAX page is load up one page, have it on your
screen and then update various parts of the web page in situ. This means
you only need to send down your page once, saving on downloads and
network traffic.

The problem with this is that web browsers loose track of what you are
doing because there is no page to load and so their history trail gets
all mucked up.

So how do we fix this? Well, with Really Simple History you can, and
easily.

What we do is when you visit a page, we insert into the history a hash
of that page and the javascript you need to get your AJAX app to display
it.

This example is going to show a simple example of going between two
pages, one is called "Products" and the other is called "Users".
Products has the url '/products/' and users has the url '/users/'. Both
are get requests for simplicity.

#### Getting and Installing Really Simple History

First stop is to get RSH from the
[downloads](http://code.google.com/p/reallysimplehistory/downloads/list)
page, the most recent version at the time of this blog post is RSH0.6.

Then, unzip it and put "rsh.js" in your /javascripts/ folder and
"blank.html" in your /public/ folder. When you put the blank.html page
there, you will over write the one that ships with Rails, this is fine.

RSH also includes a minified version in 'rsh.compressed.js' which you
can put in your javascripts directory and replace the rsh.js file, but
while debugging stuff, and getting this working, use the non minified
version, it makes it easier (possible?) to see what went wrong.

#### Modify application.html.erb

First you have to include the rsh javascript file in your
application.html.erb file (or whatever your layout template is) by
doing:

``` html
<%= javascript_include_tag "rsh" %>
```

Now you need to put the required javascript into application.html.erb so
that your app fires up the history pages when your page loads... do this
by putting the following javascript into your

```<head>
```
```</head>
```
section of your web template, make sure it is after all your javascript
include tags:

``` javascript
<script type="text/javascript">
window.dhtmlHistory.create({
  toJSON: function(o) {
    return Object.toJSON(o);
  },
  fromJSON: function(s) {
    return s.evalJSON();
  }
});

var pageListener = function(newLocation, historyData) {
  eval(historyData);
};

window.onload = function() {
  dhtmlHistory.initialize();
  dhtmlHistory.addListener(pageListener);
}
</script>
```

The above links your page into the RSH framework. The important bit is
the var pageListener, as this is what fires when you use your back and
forward buttons after populating the history. In our case, we just want
to call eval on whatever we store in the history cache and allow it to
execute as Javascript.

#### Adding history magic to your RJS template

Now when we go to the products and users page, we are using javascript
to render them, our controllers look something like this:

``` ruby
# ProductsController:
class ProductsController

  def index
    @products = Product.find(:all)
    respond_to do |wants|
      wants.js
      wants.html
    end
  end

end

# UsersController
class UsersController

  def index
    @users = User.find(:all)
    respond_to do |wants|
      wants.js
      wants.html
    end
  end

end
```

When the user navigates to the Users index page via a AJAX call using
link_to_remote or the like, Rails will see it is a Javascript request
and then render index.js.rjs which might look like this:

``` ruby
# app/views/users/index.js.rjs
page.replace_html('MainContent', :partial => users)
```

Which replaces the Main Content div with the users partial
(automatically passing to it the \@users instance variable)

So what we want to do here is add into the RJS template a call to add in
the history link. We can do this like so:

``` ruby
# app/views/users/index.js.rjs
page.replace_html('MainContent', :partial => 'users')
page << %[dhtmlHistory.add("users", "new Ajax.Request('/users/', {asynchronous:false, evalScripts:true, method:'get'});")] 
```

Then in the products RJS template we do the same thing (but for the
products page instead):

``` ruby
# app/views/products/index.js.rjs
page.replace_html('MainContent', :partial => 'products')
page << %[dhtmlHistory.add("products", "new Ajax.Request('/products/', {asynchronous:false, evalScripts:true, method:'get'});")] 
```

That is it!

#### Testing it out

Now, go to your home page and click an AJAX link to pull up your
products page, you will see in the browser URL address bar the
following: http://127.0.0.1:3000/#products and your products page should
show. Then click (from your products page) on an AJAX link to get to
your users page, and the page should load and then you should see
http://127.0.0.1:3000/#users

Now, hit the back button and after a short lag, your products page
should reappear! Click the forward button and your users page will
appear.

What is happening is that the RSH framework is looking in the history
and finding the previous page you went to, it is then pulling up the
javascript associated with that page and executing it, in this case, a
get request to the server, just as if you had clicked on an AJAX link.
The Rails server then handles this as any other request and sends back a
response, which calls up your RJS template and renders it to the
browser...

Simple hey?

Of course there are many other things you can do, you don't have to
store get requests, you can story any arbitrary javascript in the value
part of the dhtmlHistory.add call, also, I tend to make a helper or two
in my application_helper.rb file to handle making the AJAX. Like this:

``` ruby
module ApplicationHelper

  def add_simple_history(name, url)
    page << %[dhtmlHistory.add("#{name}", "new Ajax.Request('#{url}', {asynchronous:false, evalScripts:true, method:'get'});")]
  end

end
```

Which then makes your RJS template look like this:

``` ruby
# app/views/products/index.js.rjs
page.replace_html('MainContent', :partial => 'products')
page.add_simple_history('products', '/products/')
```

Much nicer.

blogLater

Mikel

