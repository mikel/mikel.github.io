---
title: "Getting Rails 2.0 and MS SQL Server Talking"
author: Mikel Lindsaar
date: 2007-12-16
layout: home
redirect_from:
  - /2007/12/16/getting-rails-2-0-and-ms-sql-server-talking
---
With version 2.0 of Rails, getting it talking to SQLServer has become a
whole lot easier.

Today I had to get a different Windows computer hooked up as a
development system to talk to our Rails installation and the Development
SQL Server.

I started trawling through the online documentations and thought, "This
must be easier".

So, I went off to get the latest One Click Ruby Installer for Windows
(1.8.6.26) and downloaded it.

After installing this, I did the following:

``` shell
c:\> gem install rails
c:\> gem install activerecord-sqlserver-adapter
--source=http://gems.rubyonrails.org
```

And then configured up my database.yml file like so:

``` ruby
development:
  adapter: sqlserver
  mode: ODBC
  dsn: app_development
  host: 127.0.0.1
```

Added similar entries for production and test and started my app...

AND IT WORKED!!!!!!

This is really cool! Lots easier than plugging in this ODBC connecter
and that Ruby DBI... the one click installer has it all already
installed.

Anyway, thought y'all might like to know.

Mikel
