---
title: "Tip #21 - Developer Info On Every Page"
author: Mikel Lindsaar
date: 2008-06-02
layout: post
redirect_from:
  - /2008/6/2/developer-info-on-every-page
---
When you are making a rails site, you sometimes need to get to the
session hash or the params hash and see just what got sent back to the
browser, but going in, editing the template and reloading is just a
PITA, here is a quick tip that can help you have that (and any other)
information no more than a click away, at any time, and any view....

What we need to do is be able to show, on any page in our site, some
quick Developer Information.

What I wanted is a little link at the bottom right of every page called
"Developer Information" and if I click it, I get a screen popping up
with all the information I need, that I could then hide away again.

I had a need for this on a site I was making, and in true Ruby style, I
thought "What is the simplest thing that could work?" Well, I think this
is about it.

First, make a file in your /app/views/common_partials folder called
'\_developer_info.html.erb'

Into this, throw the following:

``` html
<a id="DevInShow" href="#" 
   style="font-size:small;position:absolute;bottom:10px;right:10px"
   onclick="$('DevInfo').show(); $('DevInShow').hide();">
 Show Developer Info</a>

<div id="DevInfo" 
     style="background:white;padding: 5px;
            border:10px solid red;position:absolute;
            top:0px;left:0px;display:none">

  <a href="#" 
     onclick="$('DevInfo').hide(); $('DevInShow').show();">
  Hide Developer Info</a>

  <h1>Params</h1>
  <pre>
    <%= params.to_yaml %>
  

```<h1>
```
Session

```</h1>
```
```<pre>
```
\<%= session.to_yaml %\>

```</pre>
```
`<a href="#" 
    onclick="$('DevInfo').hide();$('DevInShow').show();">`{=html}\
Hide Developer Info`</a>`
```</div>
```
```</pre>
```
```

The above code sets up a hidden div in your view with a link at the
bottom right. When you click the link it makes the hidden div visible
(which is absolutely positioned over the top of all your content) and
gives you a link to click it away again. Neat.

Now, to make all this Rails-foo goodness work, add the following to the
very bottom of your application.html.erb file, just before the
\</body&gt; tag is good.

``` ruby
<%- if RAILS_ENV == "development" -%>
  <%= render :partial => 'common_partials/developer_info' %>
<%- end -%>
```

This renders the developer info link, only in development mode, just to
be safe :)

Of course, you will want to remove this from your pages when you go
live, but it is really handy when you are debugging session or params
movements in your code.

Enjoy!

blogLater

Mikel

