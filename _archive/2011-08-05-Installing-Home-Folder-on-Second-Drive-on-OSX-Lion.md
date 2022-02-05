---
title: "Installing Home Folder on Second Drive on OSX Lion"
author: Mikel Lindsaar
date: 2011-08-05
layout: post
redirect_from:
  - /2011/8/5/Installing-Home-Folder-on-Second-Drive-on-OSX-Lion
  - /2011/8/6/Installing-Home-Folder-on-Second-Drive-on-OSX-Lion
---
I have a 15" Macbook Pro, early 2010 model. It had a 500Gb Seagate 7200
RPM Momentus\
drive in it, and had been serving me well over the past year but I
wanted to give it\
a speed boost, so I purchased a 240Gb SSD for the OS drive and new 500Gb
Seagate Hybrid\
drive with an OWC optical bay mounting kit for the data drive.

Installation was a bit of a pain as my user data was close to 250Gb
alone, so it was\
impossible to restore this completely to the OS drive.

To handle this I did the following:

1.  Make sure you have a complete backup before you do this! I hope my
    instructions are correct, but this post has the standard MIT licence
    :)
2.  Create a "restore" user with admin rights
3.  Replace out the optical drive with the 500Gb Hybrid
4.  Log in as the "restore" user
5.  Format the new 500Gb drive as a single big partition calling it
    "data"
6.  Make a /Users folder on the data drive
7.  While logged in as the "restore" user, copy (just using Finder is
    fine) my home directory in the /Users folder from the internal drive
    and dump it into the data drive - this can take some time :)
8.  Once the copy is complete open up System Preferences, accounts and
    right click on my user account and select "Advanced Options", in
    there change the path to the home folder to the new folder on the
    data volume
9.  Log out of the "restore" user and log in as your own user again, you
    should now have the home folder in the new location (the folder will
    have the home icon in finder)
10. Note, when logging back in as yourself, some applications might
    complain that they can't find the old folder, Dropbox is one of
    these culprits as they use an absolute path, not a relative one.
    Just relink as needed.
11. Delete the old home folder in "/Users/yourloginname" (or move it to
    external storage for safe keeping if you are still in disbelief that
    everything worked)

Now we are ready to replace the internal OS drive. One thing I found
though was that even after I deleted my home folder, the free space
didn't drop! It stayed stuck where it was. This made me think it was
some sort of trash or recycle bin, but what I found is that there is a
directory called /.MobileBackups on your drive that is like a mini
portable time machine. So if you have time machine on, but you are not
connected to it when it is time to backup, Lion will take a snapshot of
your drive of changes. Neat, but in this case annoying.

So I had to do the following to replace the Internal drive:

1.  Replace the internal OS drive with the new shiny SSD
2.  Put the old internal drive into a USB enclosure
3.  Connect USB enclosure to mac and restart into the recovery mode
    (Hold down Command-R until you see the apple logo)
4.  Once in recovery mode, go into Disk Utility and note the name of
    your old Internal drive that is now connected via USB, it will be
    called something like "Macintosh HD" or some custom name if you have
    changed it.
5.  Quit disk utility and go into the to terminal app.
6.  Change to the folder where your USB drive is mounted, if your drive
    is called Macintosh HD then do: "cd /Volumes/Macintosh\\ HD"
7.  Check to see if the MobileBackups folder exists with "ls -al"
8.  Forcibly delete the MobileBackups folder if it exists with "rm ~~rf
    .MobileBackups"~~ this can also take some time, in my case this
    folder had over 300gb in it
9.  Once delete see how much space is left with "df -hi" It will show
    how many Gb have been used and what is available, make sure your old
    internal drive now has less used than is available on your new SSD
    drive.
10. Quit terminal and fire up Disk Utility
11. Click on your old internal drive connected via USB, and click the
    "Restore" tab. Then drag the new SSD drive from the sidebar into the
    Destination box. This will copy the contents of the old Internal
    drive onto your SSD drive.
12. Get this started (the confirmation box here is actually quite good
    and tells you what is going to happen clearly).
13. Come back in an hour or two.
14. Now that the SSD drive has everything your old internal drive had,
    the moment of truth has come, the reboot. Quit time machine, and
    then restart choosing your new SSD drive as the boot source, for
    added assurance, I disconnected my USB drive at this point.
15. Your mac should now restart on your new internal SSD drive a lot
    faster than before.

And that's it!

blogLater

Mikel

