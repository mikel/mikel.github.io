---
title: "Installing Ruby 1.9 on Mac OSX"
author: Mikel Lindsaar
date: 2008-01-17
layout: post
redirect_from:
  - /2008/1/17/installing-ruby-1-9-on-mac-osx
  - /2008/1/16/installing-ruby-1-9-on-mac-osx
---
If you have ruby and a mac, no doubt you want to try out 1.9 - but be
warned, some things can break! This little tutorial shows you how to
install Ruby 1.9 in parallel to your 1.8.x installation... which can be
handy...

Especially useful if you are developing an application in Ruby and want
to test against 1.8.x and 1.9.

The goal here is to end up with a set of tools that can be 1.8 or 1.9 at
will. The way I will do it is that you will end up with "ruby" and "irb"
and "rake" and "gem" all pointing to your existing version of Ruby (be
that 1.8.6 or 1.8.5 or whatever). Then you will get another set of tools
like "ruby-trunk", "irb-trunk", "rake-trunk" and "gem-trunk" that will
point to the 1.9 versions of these programs.

So, sound good? Great, enough talk, lets get started.

### Getting Ruby

You can download Ruby 1.9 from http://www.ruby-lang.org/en/downloads/

### Getting Read Line

You will most likely need Read Line 5.2 (Ruby 1.9 needs it), so you can
get it from the [readline GNU page](http://ftp.gnu.org/gnu/readline/)

### Installing ReadLine

Do the following from your home directory:

``` shell
baci:~ mikel$ tar xvzf readline-5.2.tar.gz 
baci:~ mikel$ cd readline-5.2
baci:~/readline-5.2 mikel$ ./configure --prefix=/usr/local/
baci:~/readline-5.2 mikel$ make
baci:~/readline-5.2 mikel$ sudo make install
```

This will make and install Read Line for you.

But if you are on Leopard, this might not work as planned, so replace
the "make" above with:

``` shell
baci:~/readline-5.2 mikel$ make static
baci:~/readline-5.2 mikel$ sudo make install-static
```

Thanks to [Sean's webblog](http://www.weblogs.uhi.ac.uk/sm00sm/?p=291)
for this tip.

### Installing Ruby 1.9

Now you need to get Ruby working, you do this by doing the following:

``` shell
baci:~ mikel$ tar xvzf ruby-1.9.0-0.tar.gz
baci:~ mikel$ cd ruby-1.9.0-0
baci:~/ruby-1.9.0-0 mikel$ ./configure --program-suffix=-trunk --with-readline-dir=/usr/local
baci:~/ruby-1.9.0-0 mikel$ make
baci:~/ruby-1.9.0-0 mikel$ sudo make install
```

Note the ./configure step? This is important because you are passing in
two options, firstly you are telling it to add -trunk to the end of each
program it makes (you could put anything you want here basically) and
secondly you are telling it where to get ReadLine from on the system.

And that's it!

To test, just try typing:

``` shell
baci:~ mikel$ irb-trunk
irb(main):001:0> RUBY_VERSION
=> "1.9.0"
```

Enjoy!

blogLater

Mikel

