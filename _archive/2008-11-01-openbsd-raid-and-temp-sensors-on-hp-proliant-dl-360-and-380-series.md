---
title: "OpenBSD RAID and Temp Sensors on HP Proliant DL 360 and 380 Series"
author: Mikel Lindsaar
date: 2008-11-01
layout: post
redirect_from:
  - /2008/11/1/openbsd-raid-and-temp-sensors-on-hp-proliant-dl-360-and-380-series
---
I have a bunch of HP DL 360 and DL 380 servers that I run OpenBSD on as
gateways. This is how to monitor their RAID drive status and temperature
status...

What you need to do is enable the IPMI driver.

If you read the man page, the IPMI driver provides an API like interface
to the hardware it is running on.

This means you can query sysctl to get data like this:

``` sh
$ sysctl hw.sensors
hw.sensors.acpitz0.temp0=8.35 degC (zone temperature)
hw.sensors.ciss0.drive0=online (sd0), OK
```

If you then yank one of a mirror set you get:

``` sh
$ sysctl hw.sensors.ciss0.drive0
hw.sensors.ciss0.drive0=degraded (sd0), WARNING
```

If you then put a new drive back into the mirror set you get:

``` sh
$ sysctl hw.sensors.ciss0.drive0
hw.sensors.ciss0.drive0=rebuilding (sd0), WARNING
```

Once the system has rebuilt, you get:

``` sh
$ sysctl hw.sensors.ciss0.drive0
hw.sensors.ciss0.drive0=online (sd0), OK
```

Which is very useful and basic data needed for monitoring systems like
Nagios.

There is a catch though, the IPMI driver is not enabled by default in
OpenBSD GENERIC (at least at 4.4). To enable it, you have two options.

At boot time, you can enable it by doing:

``` sh
>> OpenBSD BOOT 640/31744 k [1.29]
use ? for file list, or carriage return for defaults
use hd(1,a)/bsd to boot sd0 when sd0 is also installed
Boot: -c
Booting...
=======snip=======
User Kernel Config
UKC> enable ipmi
441 ipmi0 enabled
UKC> quit
```

This will then boot normally and if everything worked, you'll have an
operational system that you can type the above commands in to query the
status of your RAID set.

If it won't start, then reboot without doing anything and it will go
back to the way it was before, then contact openbsd misc with a copy of
your dmesg.

If it all worked, you'll probably want to enable this feature
permanently, to do this, use the config(8) utility like so:

``` sh
# config -u -o /bsd.new -e /bsd
(tells you about the kernel)
Enter 'help' for information
ukc> enable ipmi
441 ipmi0 enabled
ukc> quit
```

This then will produce an output file /bsd.new which is your new kernel.

To install the new kernel, do something like this:

``` sh
# cp /bsd /bsd-original && cp -f /bsd.new /bsd
```

And then you can reboot to an IPMI enabled system.

Enjoy.

