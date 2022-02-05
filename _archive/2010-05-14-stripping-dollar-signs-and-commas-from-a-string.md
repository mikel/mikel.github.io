---
title: "Stripping dollar signs and commas from a string"
author: Mikel Lindsaar
date: 2010-05-14
layout: post
redirect_from:
  - /2010/5/14/stripping-dollar-signs-and-commas-from-a-string
---
It is moments like these that you realise why it is you love Ruby so
much...

Today was one of those moments with the String class's `:delete` method.

I have used this method many, many times in the past.. and this is
nothing new for me... but it was one of those moments where I just went
"Gee, I love coding in Ruby..." and I wanted to share :)

If you ever need to convert, say `$12,345.12` into a single float number
like `12345.12` a Ruby newbie, might do something like this:

``` {.ruby lang="ruby" data-caption="how not to do it"}
"$12,345.12".gsub("$",'').gsub(",",'') #=> "12345.12"
```

But hark! Look into the [string
class](http://ruby-doc.org/core/classes/String.html) and you shall find
the `:delete` method, which lets you do this:

``` {.ruby lang="ruby" data-caption="how not to do it"}
"$12,345.12".delete("$,") #=> "12345.12"
```

Ahhh... pure Ruby bliss.

blogLater

Mikel

