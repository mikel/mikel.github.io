---
title: "Custom Music on Hold for Asterisk"
author: Mikel Lindsaar
date: 2009-07-03
layout: home
redirect_from:
  - /2009/7/3/custom-music-on-hold-for-asterisk
  - /2009/7/2/custom-music-on-hold-for-asterisk
---
I needed to change the music on hold for my Asterisk servers...

First, find your favorite music files in basically any format, get them
somewhere where you can access them.

Then make sure you have ffmpeg installed, for mac users you can just do
"port install ffmpeg" which can take a while as it has to install all
the audio and video format libraries.

Go into the folder where you put the music files, and run the following
(assuming you are on a UNIX client)

``` sh
for f in `ls *.mp3` ; do FILE=$(basename $f .mp3) ;
  ffmpeg -i $FILE.mp3 -ar 8000 -ac 1 -ab 64 $FILE.wav \
  -ar 8000 -ac 1 -ab 64 -f mulaw $FILE.pcm \
  -map 0:0 -map 0:0 ;
done
```

This will change your "MP4" files into a PCM (ulaw) and WAV file format.

Then move the existing music on hold directory in asterisk to another
name:

``` sh
# mv /var/lib/asterisk/moh /var/lib/asterisk/moh-original
# mkdir /var/lib/asterisk/moh
```

Then install your new music files

``` sh
# cp ~/*.pcm /var/lib/asterisk/moh/
# cp ~/*.wav /var/lib/asterisk/moh/
```

Then reload Asterisk and you should be good to go!

Mikel
