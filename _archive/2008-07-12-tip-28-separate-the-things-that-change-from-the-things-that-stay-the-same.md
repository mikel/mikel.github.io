---
title: "Tip #28 - Separate the things that change from the things that stay the same"
author: Mikel Lindsaar
date: 2008-07-12
layout: home
redirect_from:
  - /2008/7/12/tip-28-separate-the-things-that-change-from-the-things-that-stay-the-same
---
When you are coding, you should try to separate out the things that
change from the things that stay the same. This isn't my idea, but it is
worth tip'n here as I just saw a really good, simple example of this...

I first read about this concept in learning about Design Patterns. Then
I also read it in Design Patterns in Ruby by [Russ
Olsen](http://www.jroller.com/rolsen/) (good book by the way).

The basic concept is that if you can spot the few lines of code in your
design that *could* change and move these out to a separate part of your
code base, when a change comes along, you just have to change one small
part of your app and you are done. You don't have to dive through lots
of classes fixing and correcting code everywhere to implement the
change.

I recently ran into a good example of this, it is the Active Record
Extensions by [Zach
Dennis](http://www.continuousthinking.com/tags/arext)

I use PostgreSQL, Zach's Active Record extensions worked out of the box
with PostgreSQL, but in the inefficient fail-safe manner, that is, it
did bulk inserts by making one complete insert statement per row, which
is per the SQL standard.

For MySQL, he had implemented the multiple insert method in SQL, which
allows you to write on "INSERT INTO..." and give it an insert array of
(in my case) 1000 rows. This cuts down on data transfer between the
client and server. Especially when you are inserting a few hundred
thousand rows.

I knew PostgreSQL also supported this, so I dove into the code base to
find a way to implement.

Happily, I found that Zach had followed the above rule to the letter. To
implement this, I had to modify *one* line in one file (to include a
module) and copy about 20 lines into another file (the MySQL versions)
and modify a few of those lines to suit PostgreSQL and I was done!

This was a good piece of code, a good example of the above and worth
looking at for a Ruby on Rails intermediate type who wants to find out
more about plugins and extending ActiveRecord.

Mikel
