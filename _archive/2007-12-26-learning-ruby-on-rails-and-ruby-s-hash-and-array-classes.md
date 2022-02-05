---
title: "Learning Ruby on Rails and Ruby's Hash and Array Classes"
author: Mikel Lindsaar
date: 2007-12-26
layout: post
redirect_from:
  - /2007/12/26/learning-ruby-on-rails-and-ruby-s-hash-and-array-classes
---
Ruby on Rails makes wonderful use of the two cornerstone Ruby classes,
Hash and Array. Here I give a short tutorial on how to use Hash and
Array with Rails.

When you are starting in Rails, you hear about "Array's" and "Hash's" of
options and parameters. If you are new to Ruby as well, this really
throws you in the deep end. Especially as the Rails convention is to not
use the optional Ruby markers for Arrays (which are usually the two
square brackets '\[' and '\]' ) and the Hash markers (usually the two
curly braces '{' and '}').

So how do you get your head around them? First idea is to put them into
your code as often as you can, this will help you learn how these things
work.

A good example is the find command that you use all the time. Did you
know that this is usually an array which contains a symbol and a hash?
No? Let me show you:

Here is a usual find method you might do:

``` ruby
Person.find :all, :limit => 10, :offset => 5
```

This tells the Person model to find 10 people after the first 5. So you
would get person number 6 through 15.

But, you could also write this as:

``` ruby
Person.find([:all, {:limit => 10, :offset => 5}])
```

You see now that the find method of Person takes a [Ruby
array](http://www.ruby-doc.org/core/classes/Array.html). The first item
of the array is the symbol :all, the second item is a [Ruby
Hash](http://www.ruby-doc.org/core/classes/Hash.html). The hash is made
up of two key / value pairs, the first pair is made up of a key (the
symbol :limit) with the value (10) and the second has a key (:offset)
with the value (5).

What Rails then does is takes this find method and pops off the Hash at
the end if it exists and processes it separately.

Why is this important?

Well, firstly, it will do you well to learn about Ruby Hash and Array, I
have the Array and Hash pages permanently bookmarked in my Web browser
as they are the most used classes along with String that I use day to
day.

But secondly, it will stop you from doing silly things like this:

For example, in Rails a single nested route is done like this:

``` ruby
map.resources :events, :has_many => :tickets
```

This is saying that all events have many tickets. This allows you to use
the new_event_tickets url helpers and all sorts of other fun stuff.

But say you also wanted attendees to be associated with events.

The initial thought might be to do:

``` ruby
map.resources :events, :has_many => :tickets, :has_many => :attendees
```

But this won't work. Why? Because this can also be written as:

``` ruby
map.resources([:events, {:has_many => :tickets, :has_many => :attendees}])
```

And you see now we have a hash that has two keys of the same value?

Well, lets fire up the console and try it out and see what happens if we
do this:

``` shell
>> {:has_many => :tickets, :has_many => :attendees}
=> {:has_many=>:attendees}
```

Ruby took the last value of the key and overwrote the previous value,
leaving us with just :has_many =\> :attendees !!

So the way to do this would be:

``` ruby
map.resources([:events, {:has_many => [:tickets, :attendees]}])
```

Or more simply:

``` ruby
map.resources :events, :has_many => [:tickets, :attendees]
```

Which now passes the array of \[:tickets, :attendees\] to the :has_many
key and this all bumps up into the resources method of map and we are
happy.

You see, finding out about Ruby's Hash and Arrays is good for you!

blogLater

Mikel

