---
title: "Ruby on Rails and SQLServer Adapter Error With Dates"
author: Mikel Lindsaar
date: 2008-01-15
layout: home
redirect_from:
  - /2008/1/15/ruby-on-rails-and-sqlserver-adapter-error-with-dates
---
I have an SQLServer that has dates before 1970. If you have this, then
you will get crashes with the latest SQL Server Adapter. This shows you
how to get around it while we get it fixed in the adapter.

The problem is that the SQL Server Adapter for Active Record returns
Time objects instead of DateTime objects when asked for a DateTime.

This then crashes because Time returns a unix time object basically,
which only starts at about 1970.

The handling is fairly simple, return a Datetime object when it is
needed instead of trying to cast to Time.

This is actually handled now in [this
patch](http://dev.rubyonrails.org/attachment/ticket/10073/sqlserver_test_datetime.patch)
but for the impatient, open up your text editor, and go to lines 105 to
107 and edit them thusly:

change:

``` ruby
if value.is_a?(DateTime)
  return Time.mktime(value.year, value.mon, value.day, value.hour,....
end
```

to:

``` ruby
if value.is_a?(DateTime)
  return DateTime.new(value.year, value.mon, value.day, value.hour,....
end
```

And all should be good!

Good luck.

Mikel
