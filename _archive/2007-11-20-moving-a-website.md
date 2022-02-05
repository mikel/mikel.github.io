---
title: "Moving a website"
author: Mikel Lindsaar
date: 2007-11-20
layout: post
redirect_from:
  - /2007/11/20/moving-a-website
---
I had to help move a website recently from a .com.au to a .org.au. I had
to dig around to find the right procedure to keep the links correct and
maintain our rankings, this is the end result:

We started this drug salvage campaign with a .com.au address years and
years ago (before I was around). This gave the wrong impression of the
organization, so later we registered .org.au. But now what to do with
all the old links pointing to .com.au? Simple. REDIRECT!

First, the site is a non-dynamic static site, a lot of people link to it
on the web as it contains anti-drug booklets. You can actually go see
them at the [Drug Salvage](http://www.drugsalvage.org.au/) website.

So the steps I took were as follows:

### Change one thing at a time

You know, this is something that you have to tell some people, but
really, in Systems Administration work, you HAVE to do this otherwise
you don't know if change A made the fault or change B did. So, change
one thing, and then test it. It is better to do this move over a couple
of days and make sure it is perfect than doing it in 10 minutes and then
having your server inaccessible to the world for a couple of days.

#### Step One - Make the new site and get it working and setup and globally accessible.

This is simple.

Take a full and complete copy of the site you are moving from and put it
in a new directory, give is the new domain name (in our case
[www.drugsalvage.org.au](http://www.drugsalvage.org.au)) and set it up.
Make sure the DNS records have all settled (you should at least give
this 24 hours to make sure they have populated around the world) and
make sure the new site is accessible from more than one location by
browsing the new domain name. The site should be exactly the same as the
old domain name, just with the domain name changed.

#### Step Two - (Optional) Setup Analytics on the new site

If you are using Google analytics, now is a good time to make a new
profile and update all the urchin calls on your pages.

#### Step Three - Setup the 301 Redirect

As I am using apache 2.0, I created a 301 redirect on the old virtual
server pointing to the new virtual server.

I got some good advice from
[here](http://www.gnc-web-creations.com/301-redirect.htm) on doing the
redirect, as I want to cross redirect every requested URL and change the
.com to a .org

I ended up adding the following to my http-vhosts.conf file inside the
VirtualHost section relating to the OLD .com.au domain name.

``` shell
RewriteEngine On
RewriteRule ^(.*)$ http://www.drugsalvage.org.au$1 [R=301,L]
```

What does this do?

Well, RewriteEngine turns on the Apache mod_rewrite module, we need
this.

Second, we make a RewriteRule.

The ^[\$\ is\ a\ regular\ expressing\ that\ says]{..*}^ =\> "from the
start of the string", .\* =\> "read everything", \$ =\> "until you hit
the end of the string", and then (.\*) =\> "put the results of the .\*
into the first match variable called \$1"

So the end result of that part is we have a regular expression variable
called \$1 which contains, say, "/take_action_against_drugs/" if we were
trying to go to
[http://www.drugsalvage.com.au/take_action_against_drugs/](http://www.drugsalvage.org.au/take_action_against_drugs/)

Now, the second part of the line is what we want to re-write the request
to.

This is fairly easy, we are just going to put out the new domain name
=\> ""http://www.drugsalvage.org.au/":http://www.drugsalvage.org.au" and
add onto it the result of \$1 which will then produce as a final result
<http://www.drugsalvage.org.au/take_action_against_drugs/>

Then the third part of the line \[R=301,L\] tells the server to tell the
client that this is a permanent (301) redirect and that it should be the
last on the chain (ie, it won't evaluate further.)

OK, once that is all in there, go to your server prompt and type:

``` shell
# apachectl2 configtest                    
Syntax OK
# apachectl2 graceful                      
```

And then go ahead and browse to every one of the previous sites pages,
you should magically get redirected to the new version.

If this is not working, double check your results, if it still doesn't
work, you can make the mod_rewrite engine log it's actions to a file by
adding the following two lines before the RewriteEngine rule.

``` shell
RewriteLog "logs/www.drugsalvage.com.au-rewrite_log"
RewriteLogLevel 3
```

You can make the loglevel higher if you want (9 gives you an insane
amount of data). Obviously make the log file somewhere you can access
easily that is not web accessible.

Once you are done working out the problems, set the RewriteLogLevel back
to 0 to disable rewrite logging.

OK. So now you should have the redirect going, what now?

#### Step Four - Update your sitemap.

You use sitemaps right? So, open up the new version in your favorite
editor and globally search and replace the old domain with the new
domain. Save it back up.

#### Step Five - Cleaning the Site

Go through the new site and find any mention of the old domain name. I
found these in email addresses and some file links. I changed these to
the new domain name or relative links.

#### Step Six - Watch it!

Make sure you monitor your web logs and check the site listings etc. It
might take a while to update all the links on the page in all the search
engines, but you should be good.

Hope that helps someone out there.

blogLater

Mikel

