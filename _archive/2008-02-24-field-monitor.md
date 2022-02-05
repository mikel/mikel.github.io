---
title: "Javascript Field Monitor"
author: Mikel Lindsaar
date: 2008-02-24
layout: post
redirect_from:
  - /2008/2/24/field-monitor
---
While working on a recent Ruby on Rails project, I needed to be able to
check the changes in the forms that were appearing on the page and
highlight those fields on change. I looked around and couldn't really
find anything I liked, so I made one.

This script is about 30 lines of code, or 594 bytes minified. What it
does is provides a [Prototype](http://www.prototypejs.org/) observer on
every field of every form on your page.

It then fires off a little script that adds "changed_field" to the class
of that element if the field has been changed to a value that is
different to the original value when the page was loaded.

This is done by comparing the original value on page load to the new
value on change.

I have made it into a zip file that includes the javascript in an
external file, a sample css file as well as a samle web page with a
basic form on it to show you how it works. The zip file also includes a
minified version as well as a copy of prototype 1.6.0.2 so you don't
have to download it separately and you can see it working "out of the
box".

#### Install It!

If you want to put it in a static web page, you need to do the
following:

Put the following in your HEAD tag of your web page:

``` html

  <script type="text/javascript" src="prototype-1.6.0.2.js"></script>

  <script type="text/javascript" src="field_monitor_mini.js"></script>

  <script type="text/javascript" charset="utf-8">

    document.observe('dom:loaded', function() {

      $$('form').each(function(form) { new FieldMonitor(form); });

    });

  </script>
```

This then loads the filed_monitor javascript, the prototype library and
then fires of a document observer to create a field monitor for every
form on the page once the DOM has loaded.

If you don't want to do every document on the page, you can just specify
one form by it's ID like so:

``` html

  <script type="text/javascript" charset="utf-8">

    new FieldMonitor('form-id');

  </script>
```

Reload your page and you should be working.

#### Ruby on Rails Integration

As I made this to work with Ruby on Rails, it is actually insanely
simple to do. You can do the static version per the above by copying the
file_monitor_mini.js file into your
`<strong>`{=html}public/javascripts`</strong>`{=html} directory and then
just putting the following into your
`<strong>`{=html}layouts/application.html.erb`</strong>`{=html} file:

``` html

  <% javascript_include_tag 'field_monitor_mini.js' %>
```

Then, you can either put the `<strong>`{=html}new
FieldMonitor('form-id')`</strong>`{=html} code in your
`<strong>`{=html}layouts/application.html.erb`</strong>`{=html} file, or
if you are using RJS Templates, put the following in your RJS:

``` ruby

page << %[new FieldMonitor('form-id');]
```

And all should be good.

#### Download It!

You can download [Field Monitor
here.](http://lindsaar.net/assets/field_monitor.zip)

Let me know if you find it useful!

blogLater

Mikel

