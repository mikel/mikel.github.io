---
title: "Windows ipconfig does not show anything"
author: Mikel Lindsaar
date: 2009-01-05
layout: home
redirect_from:
  - /2009/1/5/windows-ipconfig-does-not-show-anything
---
I had a Windows XP system (service pack 2) that would only return
"Windows IP configuration" and then nothing, no indication of network
disconnection nothing, well, there's a good fix for it.

The system wouldn't pickup an IP address from DHCP, it was like it was
just confused.

You can do the following at a CMD prompt to reset the network
configurations:

``` sh
C:\> netsh winsock reset catalog
C:\> netsh int ip reset reset.log
```

The first line resets all the WINSOCK entries to their defaults, the
second line resets all the TCP/IP entries to their defaults.

The first one will ask you to reboot, don't. Do both commands and then
reboot your system.

Once I did this, the computer got it's DHCP address again quite happily.

blogLater

Mikel
