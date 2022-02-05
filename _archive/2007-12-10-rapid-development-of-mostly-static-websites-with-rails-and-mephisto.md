---
title: "Rapid Development of Mostly Static Websites with Rails and Mephisto"
author: Mikel Lindsaar
date: 2007-12-10
layout: post
redirect_from:
  - /2007/12/10/rapid-development-of-mostly-static-websites-with-rails-and-mephisto
---
"Mikel, I need a website to promote the Drug education campaign we are
doing, needs a contact form, signup form and lots of basic information,
oh, it would be good if it could have a blog on it as well - maybe in
the future."

This was the brief I got a few weeks ago to make
http://www.drugfacts.org.au/...

Now, I love Ruby on Rails, but the idea of deploying a whole application
to handle such a simple site (5 or so pages, a few customizations, basic
blog with comments on one section, contact form) just made me shudder.
Deploying an entire rails app for this would mean allocating a whole
mongrel to it, making the thing, creating a user interface so that the
end user could update the site themselves etc etc etc.

Not to mention the following comment I got a few days later "Oh, maybe
we want to fix up the other site we have for the Drug Free
Ambassadors... can your Rails thing do that too?"

Hmm... of course it could. Just how long did I have to do this?

My work with Drug Facts is volunteer based, I don't have a huge amount
of time to devote to it, so instead, I decided to work smarter... as DHH
said once "If it is too hard you are not cheating enough".

I had recently changed my blog over to Mephisto, and while doing that
realised "Hey! This isn't a blogging system, this is a FULL STACK SUPER
BLOGGING SYSTEM!"

Well.. maybe not those exact words, but I thought I would give you the
rundown of how I got from nothing to two sites up in about 2 real days
of work, using Mephisto.

#### Stage One: Design and Planning

![](http://lindsaar.net/assets/2007/12/9/initial.jpg)

It amazes me how many people dive into stuff without sort of figuring
out what is going on. So, first step in making a basic site like this is
planning out what you are going to do. I got an image from the boss that
she would like to design the site around. This was really cool because
it let me just get on with the basic design. Her initial concept is on
the left here.

We decided there would be 6 major pages, plus the home page. The Help
Out page would include a contact form and the Drug Facts and True High
sections would have feedback spots - like a blog, but with static
content.

With this in mind, I went to iStockPhoto and paid for and downloaded the
base image, then, I fired up Adobe Illustrator and turned this image
into a website front page, image and graphics heavy, but that's OK for
this site as it is meant to be that way.

I cleaned up some of the layout and images - sliced and diced it up and
turned it in this:

![](http://lindsaar.net/assets/2007/12/8/drugfacts_1.jpg):http://www.drugfacts.org.au/

Now I had my basic design in place, and knew what each sub page
(section) was going to be called, I went to Mephisto.

#### Stage Two: Installing Mephisto on a Development System

I develop everything locally and then upload to a server for production,
this means that I had to set up the whole development environment on my
laptop. Running MacOSX meant that this was fairly trivial.

The complex bit was getting Mephisto to act like a multi site website on
my laptop and then deploy to a server where it would do the same.

First off, get the code!

So, in an SVN repository I have, I made a directory and checked out
Mephisto Edge.

``` shell
baci:~ mikel$ svn co http://svn.techno-weenie.net/projects/mephisto/trunk mephisto
```

Now, we are going to get the latest set of rails for this. You can get
it through sudo gem install rails, but because we are making an app that
is going to deploy to a remote server, I like freezing my version of
rails right into the app tree, that way, whatever version of rails is
installed in the system, I know the exact version of rails my app is
going to run, so:

``` shell
baci:~/mephisto mikel$ rails:freeze:edge TAG=rel_2-0-1
```

We need to also make sure that we have the TZ Info gem installed:

``` shell
baci:~/mephisto mikel$ sudo gem install tzinfo
```

We may as well grab the latest version of TMail (ActionMailer in Rails
2.0 bundles TMail, but if you install the latest version via the gem,
ActionMailer will use the gem version instead of the older bundled
version)

``` shell
baci:~/mephisto mikel$ sudo gem install tmail
```

Finally, we need to set up our development database. I like using SQLite
for my development and test databases, mainly because the test database
can be in RAM (and so insanely faster) and the dev database is a no
brainer to set up.

Mephisto ships with a database.example.yml file in the config directoy,
you can look through this to see examples for the production database
you use, but otherwise, just create a database.yml file and put the
following in it:

``` ruby
development:
  adapter: sqlite3
  database: db/development.sqlite

# Warning: The database defined as 'test' will be erased and
# re-generated from your development database when you run 'rake'.
# Do not set this db to the same as development or production.
test:
  adapter: sqlite3
  database: ":memory:"

production:
  adapter: mysql
  database: drugfreeambassadors
  username: rails
  password: password_string_here
  host: localhost
```

Now, we have a database set up for our development database, we are
ready to boot strap the Mephisto installation. So get into the Mephisto
directory we made via SVN and type:

``` shell
baci:~/mephisto mikel$ rake db:bootstrap
```

What this command does is runs all the migrations that Mephisto needs to
operate against your development DB.

You should see a lot of migrations fly past on the screen and end up
with something like:

``` shell
Thank you for trying out Mephisto 0.7.3: Noh-Varr Edition!

Now you can start the application with script/server, visit 
http://mydomain.com/admin, and log in with admin / test.

For help, visit the following:
  Official Mephisto Site - http://mephistoblog.com
  The Mephisto Community Wiki - http://mephisto.stikipad.com/
  The Mephisto Google Group - http://groups.google.com/group/MephistoBlog
```

You can confirm that your development database was created by checking
in the db/ folder, you should see in there a file called
development.sqlite that is about 33k in size.

OK, now, because we are setting this up to hold multiple sites, lets get
in there and enable multiple sites off the bat. But to do that you need
to get your local development system able to recognize and re-route
multiple domain names to the same Mephisto application. Sounds like a
new section to me!

#### Getting Apache to Redirect to Mephisto for Development

OK, so there are several things we need to do here:

1.  Get domain names setup that point to our Mephisto installation
2.  Get Apache recognizing that these domain names need to go to our
Mephisto app
3.  Get Apache redirecting correctly to the Mephisto app
4.  Get Mephisto serving up the right site for the domain requested.

So lets hit this one by one.

##### Setting up the domain names

We are developing first, then deploying, so we need some hostnames that
only work on our development system, that our development copy of Apache
understands and can handle. ie, we don't want to put our
"dev.drugfacts.org.au" hostname out into the internet and we don't plan
on making our development machine accessible from the Internet.

The easiest way to do this is to add an entry into /etc/hosts like so:

``` shell
baci:~/mephisto mikel$ sudo vi /etc/hosts
```

Then enter the following at the bottom of this file:

``` shell
dev.domain1.org 127.0.0.1
dev.domain2.org 127.0.0.1
dev.domain3.org 127.0.0.1
```

OK, save that file. Of course, instead of "dev.domain1.org" you would
put the actual domain name of the site you will be using, in my case it
was dev.drugfacts.org.au

Now you should be able to do the following:

``` shell
baci:~ mikel$ ping -c 1 dev.domain1.org
PING dev.domain1.org (127.0.0.1): 56 data bytes
64 bytes from 127.0.0.1: icmp_seq=0 ttl=64 time=0.056 ms

--- dev.domain1.org ping statistics ---
1 packets transmitted, 1 packets received, 0% packet loss
round-trip min/avg/max/stddev = 0.056/0.056/0.056/0.000 ms
baci:~ mikel$ ping -c 1 dev.domain2.org
PING dev.domain2.org (127.0.0.1): 56 data bytes
64 bytes from 127.0.0.1: icmp_seq=0 ttl=64 time=0.057 ms

--- dev.domain2.org ping statistics ---
1 packets transmitted, 1 packets received, 0% packet loss
round-trip min/avg/max/stddev = 0.057/0.057/0.057/0.000 ms
baci:~ mikel$ ping -c 1 dev.domain3.org
PING dev.domain3.org (127.0.0.1): 56 data bytes
64 bytes from 127.0.0.1: icmp_seq=0 ttl=64 time=0.055 ms

--- dev.domain3.org ping statistics ---
1 packets transmitted, 1 packets received, 0% packet loss
round-trip min/avg/max/stddev = 0.055/0.055/0.055/0.000 ms
```

OK, the plumbing looks good.

##### Setting up the Development Apache server

Now, get into your apache config file, on a mac, it is in
/etc/httpd/httpd.conf

``` shell
baci:~ mikel$ sudo vi /etc/httpd/httpd.conf
```

Now, you need to do a couple of things. First, we need Apache being able
to be a forward proxy, so you need to enable the following lines (take
the \# out from in front of them:)

``` shell
LoadModule rewrite_module     libexec/httpd/mod_rewrite.so
LoadModule proxy_module       libexec/httpd/libproxy.so
#
# (quite a few lines)
#
AddModule mod_rewrite.c
AddModule mod_proxy.c
```

This will allow Apache to rewrite the incomming URLs and also act as a
forwarding proxy to our mongel running the Mephisto app.

Now go to the end of the httpd.conf file and add the following:

``` shell
<VirtualHost *:80>
ServerName dev.domain1.org
DocumentRoot /Users/mephisto/public
ServerAdmin webmaster@localhost
ServerAlias dev.domain2.org dev.domain3.org

RewriteEngine On

#RewriteLog /Users/mikel/dfa_rewrite.log
#RewriteLogLevel 8  

# Check for maintenance file and redirect all requests
RewriteCond %{DOCUMENT_ROOT}/system/maintenance.html -f
RewriteCond %{SCRIPT_FILENAME} !maintenance.html
RewriteRule ^.$ /system/maintenance.html [L]

# Don't rewrite Admin directory
RewriteCond %{REQUEST_URI} ^/admin.*
RewriteRule ^(.*)$ http://%{HTTP_HOST}:3000%{REQUEST_FILENAME} [P,QSA,L]

# The first rewrite rule inserts the domain name into URLs that begin
# with /assets. It first checks to see if the file exists, which may
# not be strictly necessary; if the file doesn't exist, you're going
# to get an error either way

RewriteCond %{REQUEST_URI} ^/assets/.*$
RewriteCond %{DOCUMENT_ROOT}/assets/%{HTTP_HOST}/$1 -f
RewriteRule ^/assets/(.*)$ /assets/%{HTTP_HOST}/$1 [QSA,L]

# The next rule rewrites the base URL to the index.rhtml file in the
# appropriate cache directory, if that file exists.

RewriteCond %{REQUEST_URI} ^/$
RewriteCond %{DOCUMENT_ROOT}/cache/%{HTTP_HOST}/index.html -f
RewriteRule ^/(.*)$ /cache/%{HTTP_HOST}/index.html [QSA,L]

# Now we need to check for any URL with a string after the domain name
# that doesn't include a period. This means it is a Rails URL, and not
# one for a static file. In this case, we want to check to see if there
# is a corresponding .html file in the appropriate cache, and if so,
# rewrite it to a URL that includes /cache/domainname/ and appends .html.

RewriteCond %{REQUEST_URI} ^/[^.]+$
RewriteCond %{DOCUMENT_ROOT}/cache/%{HTTP_HOST}%{REQUEST_FILENAME}.html -f
RewriteRule ^/(.*)$ /cache/%{HTTP_HOST}%{REQUEST_FILENAME}.html [QSA,L]

# For static files that may be in the cache, we do a similar rewrite but
# without appending .html. This rule applies only to URL strings that
# include a period, indicating a static file (ending is something
# like .css or .jpg).

RewriteCond %{REQUEST_URI} ^/.+$
RewriteCond %{DOCUMENT_ROOT}/cache/%{HTTP_HOST}%{REQUEST_FILENAME} -f
RewriteRule ^/(.*)$ /cache/%{HTTP_HOST}%{REQUEST_FILENAME} [QSA,L]

# And finally, anything that wasn't matched by any of the above rules is
# simply sent to Rails. In my case, this means invoking Mongrel Cluster,
# and the cluster is named dfa_mongrel_cluster.

RewriteRule ^/(.*)$ http://%{HTTP_HOST}:3000%{REQUEST_FILENAME} [P,QSA,L]

</VirtualHost>
```

I took the above basic config from the [Technology for
Human's](http://www.mslater.com/2007/6/1/setting-up-mephisto-for-multiple-sites)
site. If you want to learn how all this works, you can read more there.

In the above example, replace out dev.domain1.org, dev.domain2.org and
dev.domain3.org right at the top with the host names you set up in the
host file above.

Now, all the plumbing should be in place, it is time to set up the
multiple sites in Mephisto.

##### Getting Mephisto to Use Multiple Sites

First off you have to tell Mephisto that you want it to run in Multisite
mode, so jump into your favorite text editor and edit the
config/initializers/custom.rb file and uncomment the line:

``` ruby
Site.multi_sites_enabled = true
```

This line is also in the production.rb file under config/environments,
but because we are installing on a development system and deploying to
production, we want the entire app in all environments to act in
multisite mode.

Save the file and jump back to the command line.

From the Mephisto dir, do the following (replace the dev.domain?.org
with your domain names as well as the titles with something that means
something to you!)

``` shell
baci:~/mephisto mikel$ ./script/console
Loading development environment (Rails 2.0.1)
>> s = Site.create(:host => "dev.domain1.org",
?> :title => "The First Domain Title")
# (lots of response code)
>> s = Site.create(:host => "dev.domain2.org",
?> :title => "The Second Domain Title")
# (lots of response code)
>> s = Site.create(:host => "dev.domain3.org",
?> :title => "The Third Domain Title")
# (lots of response code)
```

Note one thing here, you need to use "drugfacts.org.au" for
www.drugfacts.org.au. Mephisto will drop any leading www. It won't drop
anything else that is leading, like "dev" or something similar, this is
important to remember for when we are deploying into a production
environment. However, for us right now, everything is prefixed with
"dev" so we use the full name.

Now we should be ready to roll!

#### Testing the basic development setup

Restart apapche from the command line:

``` shell
baci:~/mephisto mikel$ sudo apachectl restart
```

Then fire up Mephisto:

``` shell
baci:~/mephisto mikel$ ./script/server
```

Mephisto should fire up on port 3000.

Once it is running, open up a web browser and go to
http://dev.domain1.org/, http://dev.domain2.org/ and
http://dev.domain3.org/ you should get three separate pages with three
different titles, if you did, well done, it works! If you didn't, see
the debugging section below.

For those of you who got it working, there is one important first step
you should do. Log into each of the virtual Mephistos and setup an admin
user for that site.

So, for domain1, browse to http://dev.domain1.org/admin/ log in as
"admin" and "test" and then go to accounts in the top right and add a
user (called your name) with a password and give them admin rights.

Then repeat for domain2 and domain3. This just makes sure you have
access to each site.

#### What if the darn thing doesn't work? (aka Debugging)

Well, it can be one of a few things.

If your web browser says that it can't find dev.domain1.org,
dev.domain2.org or dev.domain3.org, you have a name resolution issue.
Take a look at the /etc/hosts file and try pinging the hostnames. Get
this working first.

If your web browser tries to load it, but you get an incorrect page up
that doesn't look anything like Mephisto, then you have a redirect or
virtual host problem. Go into your apache config and look at the virtual
host entry I had you put in. There are two lines which you should
uncomment:

``` shell
RewriteLog /Users/mikel/debug_rewrite.log
RewriteLogLevel 8  
```

Of course, change /Users/mikel/ to your username for this to work. Stop
and restart the apache server (sudo apachectl restart) and then tail the
debug_rewrite.log file for information about what is going wrong. (you
tail a file by going into the console and typing "tail -f
/Users/mikel/debug_rewrite.log"). Once you are tailing it, try browsing
to the websites. Apache will write an entry into this file for every
request it attempts to rewrite. There will be a lot of entries, so only
do a bit at a time. If you have real problems, pastie your log somewhere
and put the link in the comments below and I'll see if I can help out.

Finally, if Apache seems to be redirecting everything but Mephisto
doesn't seem to be giving you the correct sites, check out the sites
table in the development database for what is actually in there.

#### Next steps

Next will be how to set up a static site with some basic pages and then
how to deploy it all to a production server.

blogLater

Mikel

