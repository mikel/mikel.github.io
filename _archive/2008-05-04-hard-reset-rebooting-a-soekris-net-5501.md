---
title: "Hard Reset / Rebooting a Soekris Net 5501"
author: Mikel Lindsaar
date: 2008-05-04
layout: post
redirect_from:
  - /2008/5/4/hard-reset-rebooting-a-soekris-net-5501
---
If you have a Soekris Net5501, sometimes they will not reboot when you
tell them to. Hanging just after the memory test. Here is how you force
them to reboot.

The only thing you have to have is a serial connection to the console
port of the Soekris. Any good network design should give you some sort
of console connection as a backup path, if you don't have access to the
console on your box from remote, you might want to work out how you can
do this.

Having a modem with dial back is one way, but I usually cross connect
boxes together so that if one fails, I can get to the console via the
serial port of another. This way, I can always get to the console of any
unit that dies.

So, the reset command is quite easy. Connect to the console and type
"+ + +" then wait about 2 seconds and type "POWER"

This will turn the Soekris off, wait about 5 seconds, and then turn it
back on again.

This is a life saver when you have a CF card that does not initialize in
time for the box to boot.

blogLater

Mikel

