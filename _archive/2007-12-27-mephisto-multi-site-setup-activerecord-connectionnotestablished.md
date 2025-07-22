---
title: "Mephisto Multi Site Setup - ActiveRecord:: ConnectionNotEstablished "
author: Mikel Lindsaar
date: 2007-12-27
layout: home
redirect_from:
  - /2007/12/27/mephisto-multi-site-setup-activerecord-connectionnotestablished
---
The Mephisto Docs tell you to put the Site.multi_sites_enabled = true
into the environments files, but this is no longer true...

In fact, in the production.rb file you will find a commented out
Site.multi_sites_enabled = true line. But beware Skywalker, this road
leads to the dark side of tearing your hair out trying to trace an
ActiveRecord::ConnectionNotEstablished error.

This is excerpted from my [Rapid Development of Mostly Static Websites
with Rails and
Mephisto](https://lindsaar.net/2007/12/10/rapid-development-of-mostly-static-websites-with-rails-and-mephisto)
blog, I had a comment that this was a problem for someone else, so I
thought I would make it easier to find.

Now, you have to tell Mephisto that you want it to run in Multisite
mode, but the environment is not the place. Where to put it? In your
initializers/custom.rb file! This file loads after your environments
load, so jump into your favorite text editor and edit the
config/initializers/custom.rb file and uncomment the line:

``` ruby
Site.multi_sites_enabled = true
```

Delete the one that is in the production.rb file.

Save the files and jump back to the command line.

Now to get the multi sites setup, from the Mephisto dir, do the
following (replace the dev.domain?.org with your domain names as well as
the titles with something that means something to you!)

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

Now you should be good to go.

blogLater

Mikel
