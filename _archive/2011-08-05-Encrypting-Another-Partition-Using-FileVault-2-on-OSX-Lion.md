---
title: "Encrypting Another Partition Using FileVault 2 on OSX Lion"
author: Mikel Lindsaar
date: 2011-08-05
layout: post
redirect_from:
  - /2011/8/5/Encrypting-Another-Partition-Using-FileVault-2-on-OSX-Lion
  - /2011/8/6/Encrypting-Another-Partition-Using-FileVault-2-on-OSX-Lion
---
After installing a second drive with my home folder on it in my MacBook
Pro, I noticed that FileVault 2 had only encrypted my main volume.

This was a problem, because most of the sensitive data is on the second
volume, with my home folder. So it had to be fixed.

The solution is quite simple:

\# Log into (or create and log into) a secondary administrator account,
I call mine "restore"

\# Make sure the second account has their home folder on the main
internal OS drive (not out on the secondary drive where your home folder
it)

\# Once logged in as the restore user, find the device name of the
secondary drive using df, in my case it is /dev/disk0s2:

```{=html}
<pre>
```
\$ df\
Filesystem 512-blocks Used Available Capacity Mounted on\
/dev/disk2 466560312 169368416 296679896 37% /\
devfs 392 392 0 100% /dev\
/dev/disk0s2 976101344 558685488 417415856 58% /Volumes/data\
map -hosts 0 0 0 100% /net\
map auto_home 0 0 0 100% /home

```{=html}
</pre>
```
\# Once logged in, run the following command from the shell:

```{=html}
<pre>
```
sudo diskutil coreStorage convert /dev/disk0s2 -passphrase 'password'

```{=html}
</pre>
```
make sure you change 'password' to something you will never forget :)

1.  The system will start encrypting your drive. Hopefully you have no
    open files on the secondary drive so that the system can dismount
    and mount your drive again and start encrypting.
2.  Complete the steps below.

This works, however, there is a problem. With your home folder now on
the second drive, it has to be unlocked BEFORE you can log in. As you
need to log in to get access to your keychain, this presents a chicken
and egg problem.

The solution is a great script created by Mr Ridgewell called
[unlock](https://github.com/jridgewell/unlock)

\# Before you logout of the restore user (assuming you didn't need to
reboot to start the encryption process due to open files), run the
following from the terminal:

```{=html}
<pre>
```
\$ bash \<(curl -s
https://raw.github.com/jridgewell/Unlock/master/install.sh)

```{=html}
</pre>
```
This will prompt you with "Do you want to automatically unlock this
drive at boot?" for each encrypted volume it detects other than the boot
partition. If you say yes, you'll need to enter the password for that
drive.

1.  Once this process is complete, restart your mac and boot up and log
    into your normal user account, you should be all good. Further, if
    you go into disk utility, you will see that the File System type has
    changed to "Mac OS Extended (Journaled, Encrypted)" for both your
    main internal and secondary volumes.

Obviously, this is only safe if your main boot partition is also
protected via FileVault otherwise your unlock key for the secondary
drive would be in plain text on the boot partition. However, I am
assuming you have FileVault 2 turned on for the main boot partition.

blogLater

Mikel

