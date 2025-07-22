---
title: "Tip #2 - Daemonize Your Gems!"
author: Mikel Lindsaar
date: 2008-04-11
layout: home
redirect_from:
  - /2008/4/11/tip-2-daemonize-your-gems
---
If you program in Ruby on Rails and or Ruby, you will find yourself
firing up "gem server" all the time, so why not make it automatic?

It is quite easy in OS X or in any flavour of Unix and even Windows.

On OSX you do the following:

First, make sure you know where your rubygems "gem" script is by typing:

``` shell
Welcome to Darwin!
baci:~ mikel$ which ruby
/usr/local/bin/ruby
baci:~ mikel$ which gem
/usr/local/bin/gem
baci:~ mikel$
```

This tells us that our default Ruby installation is in
/usr/local/bin/ruby and the rubygems "gem" command is in
/usr/local/bin/gem. We need this for later.

If you have more than one copy of Ruby installed, you might want to make
sure you are hitting the right version, so go ahead and check like this:

``` shell
baci:~ mikel$ /usr/local/bin/ruby -v
ruby 1.8.6 (2008-03-03 patchlevel 114) [i686-darwin8.11.1]
baci:~ mikel$ /usr/local/bin/gem -v
1.1.0
```

OK, looks good.

Now, in the Unix environment, there are things called "rc" scripts, (rc
stands for "run commands" by the way), on BSD based unix systems, you
put things that you want to start up at boot time in a file called
/etc/rc.local.

Mac OSX is a BSD Unix at heart, so I expect it should have some rc
scripts in the /etc/ folder. And, if you look, you will find some!

There is rc, rc.common, rc.netboot and rc.shutdown, but no rc.local.

Hunting through the rc file though, you will find this command:

``` shell
if [ -f /etc/rc.local ]; then
        sh /etc/rc.local
fi
```

Eureka! That says (in the shell scripting language) if a file called
rc.local exists, run it by passing it to a new shell interpreter.

So, all that is left now is to make a file called rc.local, and put the
gem server in there. Make a new file, and put the following in it:

``` shell
if [ -f /usr/local/bin/ruby ]; then
  if [ -f /usr/local/bin/gem ]; then
    /usr/local/bin/ruby /usr/local/bin/gem server --daemon
  fi
fi
```

Now, save this file in your home directory and call it "rc.local". Then
go back to the shell and type the following to install it into the
correct location:

``` shell
baci:~ mikel$ sudo mv rc.local /etc/
baci:~ mikel$ sudo chown root:wheel /etc/rc.local
baci:~ mikel$ ls -al /etc/rc.*
-rw-r--r--   1 root  wheel  1633 Jul  2  2006 /etc/rc.common
-rw-r--r--   1 root  wheel   140 Apr 13 00:08 /etc/rc.local
-rw-r--r--   1 root  wheel  4413 Jul  2  2006 /etc/rc.netboot
-rw-r--r--   1 root  wheel   183 Jul  2  2006 /etc/rc.shutdown
baci:~ mikel$
```

Now reboot your mac, don't worry, I'll still be here.

Once you have rebooted it is time to see if your gem server fired up!

Go ahead and open a browser to http://127.0.0.1:8808/ - It should just
fire up.

You can see it running by typing the following at a command prompt:

``` shell
baci:~ mikel$ ps -ax | grep gem
  842  ??  S      0:00.11 /usr/local/bin/ruby /usr/local/bin/gem server --daemon
```

Now, one thing with this is that if you install some new gems, you will
have to restart the server before you will see any changes. You can do
this by finding the process id (the first number in the ps output) and
then sending it a kill command and restarting. Like this:

``` shell
baci:~ mikel$ ps -ax | grep gem
  842  ??  S      0:00.11 /usr/local/bin/ruby /usr/local/bin/gem server --daemon
baci:~ mikel$ kill 842
baci:~ mikel$ /usr/local/bin/ruby /usr/local/bin/gem server --daemon
Starting gem server on http://localhost:8808/
```

There you go! Now you can always have your gem server running for
whenever you need it without having to dedicate a command window for the
task.

blogLater

Mikel
