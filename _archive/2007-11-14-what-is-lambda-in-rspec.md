---
title: "Why use lambda in RSpec?"
author: Mikel Lindsaar
date: 2007-11-14
layout: post
redirect_from:
  - /2007/11/14/what-is-lambda-in-rspec
---
RSpec allows you to write nice readable tests... and some little tricks
make it even nicer! And I don't know about you, but the word lambda is
(1) ugly, (2) means basically bugger all and (3) is hard to pronounce
late at night... so lets replace it!

How about this for a spec:

``` ruby
doing { 
  @my_object.function 
}.should raise_error(ArgumentError, "Unknown tag type")
```

Nice and readable..

Of course, it is functionally the same as:

``` ruby
lambda { 
  @my_object.function
}.should raise_error(ArgumentError, "Unknown tag type")
```

But MUCH easier to read!

To get it to work in rails, put the following line of code into your
spec_helper.rb file.

``` ruby
 alias :doing :lambda 
```

Simple heh?

blogLater

Mikel

