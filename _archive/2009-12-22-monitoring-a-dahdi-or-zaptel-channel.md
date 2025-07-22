---
title: "Monitoring a DAHDI or Zaptel Channel "
author: Mikel Lindsaar
date: 2009-12-22
layout: home
redirect_from:
  - /2009/12/22/monitoring-a-dahdi-or-zaptel-channel
---
Sometimes you need to listen to a DAHDI channel or listen to a Zaptel
channel on an Asterisk box, here is how you do it.

If you need to listen to Zaptel Channel 1, then you would do:

``` shell
# ztmonitor 1 -m -r rx.raw -t tx.raw
```

This will make two files, one for the received stream and one for the
transmitted stream.

If you are on DAHDI, you can do:

``` shell
# dahdi_monitor 1 -m -r rx.raw -t tx.raw
```

(exit both of them with CTRL-C when done)

Once you have these files, you can play it on the box you are on with

``` shell
# play -r 8000 -s -2 -c 1 -t raw rx.raw
# play -r 8000 -s -2 -c 1 -t raw tx.raw
```

But usually you are on a server, in which case you might be wondering
"how can I play a raw file?". Well, luckily you don't have to, you can
just type:

``` shell
# sox -r 8000 -s -2 -c 1 -t raw rx.raw rx.wav
# sox -r 8000 -s -2 -c 1 -t raw tx.raw tx.wav
```

And now you will have two files called rx.wav and tx.wav on your system
that you can transfer to your laptop can play to your hearts content.

blogLater

Mikel
