---
title: "Always getting an invalid authenticity token error"
author: Mikel Lindsaar
date: 2009-05-02
layout: home
redirect_from:
  - /2009/5/2/always-getting-an-invalid-authenticity-token-error
---
I had a Ruby on Rails app giving a bunch of invalid authenticity token
errors. I spent a while hunting down the solution until I found this
write up. Very useful.

This write up was by [Peter De
Berdt](http://www.workingwithrails.com/person/5484-peter-de-berdt) on
one of the Ruby mailing lists, I am putting it here more for my own
future (maybe) reference as it is a very good solution for the situation
I was running into. The entire thread is at the [ruby forum
site](http://www.ruby-forum.com/topic/167917#751085)

If you have a situation where you are getting invalid authenticity
tokens and are doing strange things with forms on your website with file
uploads etc, and can't for some reason just use the authenticity form
helper, then this solution worked for me and should work for you too.

```<hr />
```
The solution is pretty simple to be honest:

In your view layout file, add this to the

```<header>
```
section:

``` html
<script type="text/javascript" charset="utf-8">
    window._token = '<%= form_authenticity_token -%>';
</script>
```

In application.js, add the following:

``` javascript
Ajax.Base.prototype.initialize = Ajax.Base.prototype.initialize.wrap(
   function(p, options){
     p(options);
     this.options.parameters = this.options.parameters || {};
     this.options.parameters.authenticity_token = window._token || '';
   }
);
```

It will automatically add the authenticity token to ALL ajax requests,\
even those you invoke from custom code (graceful degrading and/or even\
delegated events for example).

A similar solution for those swapping out Prototype with JQuery has\
been posted
[here](http://henrik.nyh.se/2008/05/rails-authenticity-token-with-jquery)

As for file uploaders, a normal field within a form (multipart=true)\
will be sent as part of the form (and isn't an ajax request in the\
first place) and shouldn't be a problem. If you are using ANY other\
"ajax" uploader, there's more to it. I already posted several times on\
how to get SWFUpload to play nicely with Rails, an overview with links\
to the appropriate posts can be found
[here.](http://groups.google.com/group/rubyonrails-talk/browse_thread/thread/45f70281a5992fa7)
