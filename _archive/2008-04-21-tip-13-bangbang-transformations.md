---
title: "Tip #13 - BangBang Transformations!"
author: Mikel Lindsaar
date: 2008-04-21
layout: post
redirect_from:
  - /2008/4/21/tip-13-bangbang-transformations
  - /2008/4/22/tip-13-bangbang-transformations
---
Ruby is marvelous, everything evaluates. Which means a lot of the time,
you can get away with things like 'if
`user..." and just depend on the existence of the `user var. But what if
you just really need a Boolean true or false? Here is a little pattern
you can use to do this...

#### Where two wrongs make a right?

Ruby you have the case that EVERYTHING except nil and false are "truthy"
(which means, they evaluate to true in a condition).

So that is why something like this can work in Ruby:

``` shell
irb(main):001:0> user = "Mikel"
=> "Mikel"
irb(main):002:0> if user
irb(main):003:1>   puts "Hello #{user}"
irb(main):004:1> end 
Hello Mikel
```

But the "value" of users in that if statement is still 'Mikel'

What if you had a method in a rails model like this:

``` ruby
def logged_in?
  true if logged_in_date != nil
end
```

That says "Return true if the logged_in_date is not nil, otherwise
return nil.

The problem with this, is that if the logged_in_date is *already* nil,
the method will return nil, not false. And nil does not equal false in
all cases.

A better way to write this would be to use the logical NOT operator, you
might know that a ! in front of any variable is a logical NOT operator.
This means, it takes whatever the value is and returns the opposite as a
true or false. So we get stuff like this:

``` shell
irb(main):001:0> true
=> true
irb(main):002:0> !true
=> false
irb(main):003:0> 1 == 1
=> true
irb(main):004:0> !(1 == 1)
=> false
```

Easy enough.

So NOT true equals false. But NOT NOT true equals true. And NOT NOT
(anything except nil and false) equals true. And NOT NOT anything that
is nil or false equals false. Confused? Let me show you the same
"logged_in?" method with some ruby goodness:

``` ruby
def logged_in?
  !!logged_in_date
end
```

What this now says is that if the logged_in_date is nil, then apply NOT
to that (which gives you true) and apply NOT to that (which will give
you false) so in that case it will return false, which is what you want!

On the other hand, if logged_in_date is ANY value (string, date,
anything) then you apply NOT to that and you get false, apply NOT again
and you get true. Which is also what you want.

So instead of returning true or nil, that method will now return true or
false, just as we expect.

Not bad for two exclamation marks!

blogLater

Mikel

