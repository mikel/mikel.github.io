---
title: "Convert Visual Basic / Microsoft Long Integer Color Values to CSS RGB Format"
author: Mikel Lindsaar
date: 2008-06-16
layout: home
redirect_from:
  - /2008/6/16/convert-visual-basic-microsoft-long-integer-color-values-to-css-rgb-format
---


Here is how to convert the microsoft way of storing color values (which
looks like 16777215 for white) into the familiar RGB CSS style HEX
values (which look like #FFFFFF) in Ruby.

``` ruby
def long_to_rgb_hex_string(val)
  r = "%x" % (val % 256)
  g = "%x" % ((val / 256) % 256)
  b = "%x" % ((val / 65536) % 256)
  "#" + [r,g,b].collect { |c| c.to_s.ljust(2, '0')}.to_s
end

long_to_rgb_hex_string(2093422) # => #6ef11f
```

Or Grant Hutchins gave this as an option from the comments:

``` ruby
def long_to_rgb_hex_string(val)
  sprintf(√¢‚Ç¨‚Ñ¢#%06x√¢‚Ç¨‚Ñ¢, val)
end
```

Any other good options? :)

blogLater

Mikel
