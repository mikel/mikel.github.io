---
title: "Tip #3 - Sexy Date Select Fields!"
author: Mikel Lindsaar
date: 2008-04-12
layout: home
redirect_from:
  - /2008/4/12/tip-3-sexy-date-select-fields
---
Tired of having 5 different pick lists or spinners to set a date on your
form? Me too, that's why calendar_date_select was made, and it's soo
easy to install...

![](https://lindsaar.net/assets/2008/4/13/screenshot_1_8_0.jpg)

Besides, doesn't this select box look much better and more user friendly
than entering e-v-e-r-y - s-i-n-g-l-e - b-i-t - o-f - t-h-e - d-a-t-e??
Aren't we web 2.0 here?

First, download the calendar_date_select files and unzip them and put
them into your public/javascripts directory.

Then put the stylesheets you want into the public/stylesheets directory.

Then in your layout/application.html.erb file put the following in the

```<head>
```
```</head>
```
section of the layout:

So it would look something like this:

``` html
<html>
  <head>
    <%= javascript_include_tag :defaults  %>
    <%= javascript_include_tag "calendar_date_select/calendar_date_select.js" %>
  </head>
  <body>
    <%= yield %>
  </body>
</html>
```

Then, in the form that you want to have the date select field, type
something like this:

``` html
<%- form_for @task do |f| -%>
  <%= label :subject, "Subject" -%>
  <%= f.text_field :subject -%>
  <%= label :due_time, "Due Time" -%>
  <%= f.calendar_date_select :due_time, 1.day.from_now -%>
<%- end -%>
```

Now, when you go to enter a date, you get a funky pick box pop up
instead of the spinners.

Neat-O!

As a bonus, you get a simple text-field box that you can just type the
date if you don't want to open the pick box, so typing "4 March 1974"
will select the right date when you save the form.

blogLater

Mikel
