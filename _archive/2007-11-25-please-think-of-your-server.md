---
title: "Please, think of your server!"
author: Mikel Lindsaar
date: 2007-11-25
layout: post
redirect_from:
  - /2007/11/25/please-think-of-your-server
---
This is the first blog entry of the RSPCS... the Royal Society of the
Performance and Care of Servers... our first target, people's abuse of
the use of ActiveRecord's "find" class method.

\<queue monty python choral choir&gt;

"Every find is sacred,`<br />`{=html}\
"Every find is great!`<br />`{=html}\
"If a find gets waaaaasted,`<br />`{=html}\
"God gets quite irate!"`<br />`
\</choir&gt;

If you have ever found yourself doing something like this:

``` ruby
a = Product.find(:all)
b = a.collect {|item| item.category == searched_for_category }
```

Then you should go and take a large optimization stick and whack
yourself with it.

Why?

Because what those two lines do is load EVERY record from the products
table into memory, and then use Ruby's Array#collect method to check out
which ones match the category... not so much inefficient as down right
glacial.

Of course, no one would EVERY do that... that would be sill and so
un-performance-like.

Yeah... right. And I have never coded without using TDD either.

If you are doing that somewhere in your code, keep reading, you shall be
enlightened...

Well, what if you did something as innocuous as:

``` ruby
a = Product.find( :all, 
                  :conditions=>["category = ?", searched_for_category])
```

Surely this is better and would pass through the pearly gates of SQL
heaven to enjoy peace and everylasting happiness?

Well, sure... if your Product table consists of a product_id and a
category_id... only.

But what if you are like a bunch of other rails developers and had in
that products table a binary field containing a photo, another
containing a thumbnail, and a text description field? Well, what that
means is that your SQL server is going to return ALL of that data on
EACH search through the table. This could very quickly add up to
megabytes of information per request... not a problem on your fast dual
core MacBookPro doing nothing but selflessly serving your every wish...
but go ahead and deploy that to a server that is going to get used more
than once a day and... oh... boy....

Well, what about this also "no problem" code:

``` ruby
serarched_for_category.products
```

Again, nice. Clean... and somewhat sexy... it is also a really good line
to show your VB.net friends who are trying to convince you that
programming in a Microsoft language is fun (this one basically floors
them by the way, especially when you show them the three lines of code
it takes to set up this association)... but again, performance? Ohhh....

Why?

Why is it these "usual" things to do in Rails are not the most
performance enhancing methods we can use in our Rails app?

Well... simple. Usually, (90% of the time), most people don't NEED a
performance increase here, and when you are developing code rapidly,
these little rails magic tricks are REALLY handy.

But when you deploy your application, you better have some performance
tools on hand and check out the results and be ready to replace out some
of these syntactic sugar bits with some down and dirty performance
enhancements.

So, what do you do? It's not so hard... don't worry:

First, lets take the first example of finding all products and then
parsing them through an array.collect statement. The performance
increase here is simple. Don't do it. Use the second method instead.

Ok?

Good. To improve the second method, instead of retrieving the ENTIRE
table, when all you really probably need is the item_id and the
description and thumbnail, try this instead:

``` ruby
a = Product.find( :all, 
                  :conditions=>["category = ?", searched_for_category],
                  :select => "product_id, description, thumbnail")
```

This now doesn't bother pulling down the larger image, just gives you
what you need to display the list of items. Then, when the user clicks
on the item they want, you can run:

``` ruby
a = Product.find(product_id)
```

And it gives you the one product you need.

There are a bunch of other performance enhancing tools you can use on
ActiveRecord. Feel free to add any below.

blogLater

Mikel

