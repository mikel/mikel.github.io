---
title: "Tip #7 - Shell Shortcuts You Should Know and Love"
author: Mikel Lindsaar
date: 2008-04-16
layout: post
redirect_from:
  - /2008/4/16/tip-7-shell-shortcuts-you-should-know-and-love
  - /2008/4/15/tip-7-shell-shortcuts-you-should-know-and-love
---
Face it, you use Ruby, you use Rails, you are going to use the shell,
either in the console or directly, here are some shortcuts I can't live
without.

Have you ever done this?

``` shell
baci:~/rails_app mikel$ ./script/generate user first_name:string
mid_name:string last_name:string address1:string address2:string
address3:string suburb:string state:string country:string
post_code:string home_phone:string work_phone:string mobile_phone:string
email:string

Couldn't find 'users' generator
baci:~/rails_app mikel$ 
```

Grr... of course, you forgot to put the word "model" before the word
"user".

You can hit the up arrow and get all the text back, but if you were like
me, you used to hit the left arrow and hold it down for about half an
hour to get to the start of the line. Well, no more. Shell Shortcuts are
your friend!

Simply type up arrow and then "**Ctrl-A**" and you are at the start of
the line.

Hit "**Ctrl-E**" and you will be at the end of the line.

Or, if you want a clean screen, "**Ctrl-L**" will do it for you.

If you make a mistake, "**Ctrl-\_**" will undo it.

And you also have cut and paste on the command line.

"**Ctrl-U**" cuts the beginning of the line to the cursor

"**Ctrl-K**" cuts from the cursor to the end of the line

and "**Ctrl-Y**" pastes whatever you have cut out back into the screen
at the cursor.

The cool thing is, all of these work within the Rails console as well!.

So, you are in the console and type:

``` ruby
>> User.find(:all, :conditions => ["user_name = ? AND first_name = ?",
                                   "mikel", "Mikel"])
```

And forget that you want to assign it to the "user" variable? Well, type
"**Ctrl-A**" and then "**user =**" and hit return and you are done.

Nice, handy time saving short cuts.

You can also find out other ones by Googling [Bash shell short
cuts](http://www.google.com/search?&amp;rls=en&amp;q=Bash+shell+short+cuts&amp;ie=UTF-8&amp;oe=UTF-8)

Of course, the above assumes you are using Bash, Ksh or other SH like
shells on Mac or \*nix

blogLater

Mikel

