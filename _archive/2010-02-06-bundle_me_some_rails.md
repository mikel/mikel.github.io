---
title: "Bundle me some Rails"
author: Mikel Lindsaar
date: 2010-02-06
layout: post
redirect_from:
  - /2010/2/6/bundle_me_some_rails
---
Bundler rocks, but you need to think differently about how to start and
run your Rails app.

### The Bundler Way

You should realise that [Bundler](http://github.com/carlhuda/bundler) is
a library management tool. This has to be in your mind when you are
getting a Rails application running on version 3.0.

For example, I had a new Rails application that I want to run with
PostgreSQL, so I go in and change database.yml to look at my PostgreSQL
database instead of the Sqlite3 database, fairly standard, straight
forward opperation.

Then starting the application console however, I got a bit of a shock:

``` shell
 $ rails c
/Users/mikel/.gem/ruby/1.8/gems/activerecord-3.0.0.beta/lib/active_record/connection_adapters/abstract/connection_specification.rb:76:in `establish_connection':
Please install the postgresql adapter: `gem install activerecord-postgresql-adapter`
(no such file to load -- pg) (RuntimeError)
  from /Users/mikel/.gem/ruby/1.8/gems/activerecord-3.0.0.beta/lib/active_record/connection_adapters/abstract/connection_specification.rb:60:in
`establish_connection'
  from /Users/mikel/.gem/ruby/1.8/gems/activerecord-3.0.0.beta/lib/active_record/connection_adapters/abstract/connection_specification.rb:55:in 
`establish_connection'
  from /Users/mikel/.gem/ruby/1.8/gems/activerecord-3.0.0.beta/lib/active_record/railtie.rb:45
...
```

This confused me for a second, I was sure that the `pg` gem was
installed on my system, and the following confirmed it for me:

``` shell
mikel@baci.lindsaar.net ~
 $ gem list pg

*** LOCAL GEMS ***

pg (0.8.0)
```

OK, but the rails app was complaining that it couldn't find it. At this
point, I did a bit of a double take, then a "D'Uh" moment hit me,
bundler does not equal rubygems.

This is an important datum, Bundler is a library management tool, and it
allows you to totally bypass the rubygems on your system.

So, first things first, bundler gives you some tools:

``` shell
 $ bundle
Tasks:
  bundle check        # Checks if the dependencies listed in Gemfile are satisfied by currently installed gems
  bundle exec         # Run the command in context of the bundle
  bundle help [TASK]  # Describe available tasks or one specific task
  bundle init         # Generates a Gemfile into the current working directory
  bundle install      # Install the current environment to the system
  bundle lock         # Locks the bundle to the current set of dependencies, including all child dependencies.
  bundle pack         # Packs all the gems to vendor/cache
  bundle show         # Shows all gems that are part of the bundle.
  bundle unlock       # Unlock the bundle. This allows gem versions to be changed
```

So "bundle check" should see if my dependencies are satisfied:

``` shell
 $ bundle check
The Gemfile's dependencies are satisfied
```

OK, so that's not the problem, so what gems does bundler say I have
installed then?

``` shell
 $ bundle show
Gems included by the bundle:
  * abstract (1.0.0)
  * actionmailer (3.0.0.beta)
  * actionpack (3.0.0.beta)
  * activemodel (3.0.0.beta)
  * activerecord (3.0.0.beta)
  * activeresource (3.0.0.beta)
  * activesupport (3.0.0.beta)
  * arel (0.2.1)
  * builder (2.1.2)
  * bundler (0.9.2)
  * erubis (2.6.5)
  * i18n (0.3.3)
  * mail (2.1.2)
  * memcache-client (1.7.8)
  * mime-types (1.16)
  * rack (1.1.0)
  * rack-mount (0.4.5)
  * rack-test (0.5.3)
  * rails (3.0.0.beta)
  * railties (3.0.0.beta)
  * rake (0.8.7)
  * sqlite3-ruby (1.2.5)
  * text-format (1.0.0)
  * text-hyphen (1.0.0)
  * thor (0.13.0)
  * tzinfo (0.3.16)
```

And there the light turns on, no "pg" listed, which I am using inside my
Rails app.

So that must mean that my `Gemfile` is not listing `pg` as a dependency,
let's check:

``` shell
# Edit this Gemfile to bundle your application's dependencies.
source :gemcutter

gem "rails", "3.0.0.beta"

## Bundle edge rails:
# gem "rails", :git => "git://github.com/rails/rails.git"

# ActiveRecord requires a database adapter. By default,
# Rails has selected sqlite3.
gem "sqlite3-ruby"

## Bundle the gems you use:
# gem "bj"
# gem "hpricot", "0.6"
# gem "sqlite3-ruby", :require_as => "sqlite3"
# gem "aws-s3", :require_as => "aws/s3"

## Bundle gems used only in certain environments:
# gem "rspec", :only => :test
# only :test do
#   gem "webrat"
# end
```

Notice, no mention of pg? Easy, I add `pg` like so:

``` shell
# ...
## Bundle the gems you use:
gem "pg"
# gem "hpricot", "0.6"
# gem "sqlite3-ruby", :require_as => "sqlite3"
# gem "aws-s3", :require_as => "aws/s3"
# ...
```

And now another check:

``` shell
 $ bundle check
The Gemfile's dependencies are satisfied
```

All good, we can also check to see if bundle is now looking for the `pg`
gem now:

``` shell
 $ bundle show
Gems included by the bundle:
  * abstract (1.0.0)
  * actionmailer (3.0.0.beta)
  * actionpack (3.0.0.beta)
  * activemodel (3.0.0.beta)
  * activerecord (3.0.0.beta)
  * activeresource (3.0.0.beta)
  * activesupport (3.0.0.beta)
  * arel (0.2.1)
  * builder (2.1.2)
  * bundler (0.9.2)
  * erubis (2.6.5)
  * i18n (0.3.3)
  * mail (2.1.2)
  * memcache-client (1.7.8)
  * mime-types (1.16)
  * pg (0.8.0)
  * rack (1.1.0)
  * rack-mount (0.4.5)
  * rack-test (0.5.3)
  * rails (3.0.0.beta)
  * railties (3.0.0.beta)
  * rake (0.8.7)
  * sqlite3-ruby (1.2.5)
  * text-format (1.0.0)
  * text-hyphen (1.0.0)
  * thor (0.13.0)
  * tzinfo (0.3.16)
```

All good, there is the `pg` gem listed, so now that all dependencies are
met, and I have the PostgreSQL database all setup, I should now be able
to start the application console:

``` shell
 $ rails c
Loading development environment (Rails 3.0.0.beta)
>>
```

And voila, we are up and running.

### Packing it Up

The cool thing about bundler that sets is apart from any other library
management system, is its ability to pack and lock your gem files.

Say you want to now give your Rails app to some other developer, you
don't know what versions of what gems they have running on their system,
so instead, you just pack away all the gems that are working for you and
then send them the whole Rails application directory, this will ship
your app and all its dependencies to your co-developer, who then can
just run the app as is without any other hoops.

First step is to pack your gems:

``` shell
 $ bundle pack
Copying .gem files into vendor/cache
  * builder-2.1.2.gem
  * text-hyphen-1.0.0.gem
  * i18n-0.3.3.gem
  * bundler-0.9.2.gem
  * arel-0.2.1.gem
  * activemodel-3.0.0.beta.gem
  * rack-mount-0.4.5.gem
  * mime-types-1.16.gem
  * mail-2.1.2.gem
  * abstract-1.0.0.gem
  * erubis-2.6.5.gem
  * thor-0.13.0.gem
  * memcache-client-1.7.8.gem
  * rack-1.1.0.gem
  * rack-test-0.5.3.gem
  * actionpack-3.0.0.beta.gem
  * rake-0.8.7.gem
  * railties-3.0.0.beta.gem
  * sqlite3-ruby-1.2.5.gem
  * activerecord-3.0.0.beta.gem
  * text-format-1.0.0.gem
  * actionmailer-3.0.0.beta.gem
  * tzinfo-0.3.16.gem
  * activesupport-3.0.0.beta.gem
  * activeresource-3.0.0.beta.gem
  * rails-3.0.0.beta.gem
```

This now has put every gem that my rails app depends on into the
vendor/gems directory, you can confirm this by checking out
`vendor/cache` which shows all the gem files listed.

You can then simply zip up the whole package and send it to your
co-developer (or use Git or whatever means you love), your opposite
number then unpacks the entire directory, goes to the root of it and
types:

``` shell
 $ bundle install
Installing abstract (1.0.0) from .gem files at /Users/mikel/Code/app/vendor/cache 
Installing actionmailer (3.0.0.beta) from .gem files at /Users/mikel/Code/app/vendor/cache 
Installing actionpack (3.0.0.beta) from .gem files at /Users/mikel/Code/app/vendor/cache 
Installing activemodel (3.0.0.beta) from .gem files at /Users/mikel/Code/app/vendor/cache 
Installing activerecord (3.0.0.beta) from .gem files at /Users/mikel/Code/app/vendor/cache 
Installing activeresource (3.0.0.beta) from .gem files at /Users/mikel/Code/app/vendor/cache 
Installing activesupport (3.0.0.beta) from .gem files at /Users/mikel/Code/app/vendor/cache 
Installing arel (0.2.1) from .gem files at /Users/mikel/Code/app/vendor/cache 
Installing builder (2.1.2) from .gem files at /Users/mikel/Code/app/vendor/cache 
Installing bundler (0.9.3) from system gems 
Installing erubis (2.6.5) from .gem files at /Users/mikel/Code/app/vendor/cache 
Installing i18n (0.3.3) from .gem files at /Users/mikel/Code/app/vendor/cache 
Installing mail (2.1.2) from .gem files at /Users/mikel/Code/app/vendor/cache 
Installing memcache-client (1.7.8) from .gem files at /Users/mikel/Code/app/vendor/cache 
Installing mime-types (1.16) from .gem files at /Users/mikel/Code/app/vendor/cache 
Installing rack (1.1.0) from .gem files at /Users/mikel/Code/app/vendor/cache 
Installing rack-mount (0.4.5) from .gem files at /Users/mikel/Code/app/vendor/cache 
Installing rack-test (0.5.3) from .gem files at /Users/mikel/Code/app/vendor/cache 
Installing rails (3.0.0.beta) from .gem files at /Users/mikel/Code/app/vendor/cache 
Installing railties (3.0.0.beta) from .gem files at /Users/mikel/Code/app/vendor/cache 
Installing rake (0.8.7) from .gem files at /Users/mikel/Code/app/vendor/cache 
Installing sqlite3-ruby (1.2.5) from .gem files at /Users/mikel/Code/app/vendor/cache with native extensions 
Installing text-format (1.0.0) from .gem files at /Users/mikel/Code/app/vendor/cache 
Installing text-hyphen (1.0.0) from .gem files at /Users/mikel/Code/app/vendor/cache 
Installing thor (0.13.0) from .gem files at /Users/mikel/Code/app/vendor/cache 
Installing tzinfo (0.3.16) from .gem files at /Users/mikel/Code/app/vendor/cache 
Your bundle is complete!
```

Now your co-developer has installed every gem they need to start your
Rails application on their system, all sitting right within the Rails
app.

Simply, this rocks.

### Lock 'n' Load

But you would have noticed that when we specified the `pg` gem above, we
did not specify a version, bundler helpfully grabbed the most recent one
we had installed and shipped that.

But when you are delopying an application to a production server, you
don't want approximates on Gem versions, you want what works. You don't
want "Well, gem xyz is now version 0.9, it was working on 0.8.2, so it
should be ok."

Bundler handles this problem as well, by locking.

Again, standing in the root of your app, just run bundle lock:

``` shell
 $ bundle lock
The bundle is now locked. Use `bundle show` to list the gems in the environment.
```

What this command does is make a Gemfile.lock file in your application's
root directory which looks like this:

``` ruby
--- 
dependencies: 
- rails: = 3.0.0.beta
- sqlite3-ruby: ">= 0"
- pg: ">= 0"
specs: 
- text-hyphen: 
    version: 1.0.0
- builder: 
    version: 2.1.2
- i18n: 
    version: 0.3.3
- bundler: 
    version: 0.9.3
- arel: 
    version: 0.2.1
- activemodel: 
    version: 3.0.0.beta
- rack-mount: 
    version: 0.4.5
- abstract: 
    version: 1.0.0
- erubis: 
    version: 2.6.5
- mime-types: 
    version: "1.16"
- mail: 
    version: 2.1.2
- thor: 
    version: 0.13.0
- memcache-client: 
    version: 1.7.8
- rack: 
    version: 1.1.0
- rack-test: 
    version: 0.5.3
- actionpack: 
    version: 3.0.0.beta
- rake: 
    version: 0.8.7
- railties: 
    version: 3.0.0.beta
- sqlite3-ruby: 
    version: 1.2.5
- text-format: 
    version: 1.0.0
- actionmailer: 
    version: 3.0.0.beta
- activerecord: 
    version: 3.0.0.beta
- pg: 
    version: 0.8.0
- activeresource: 
    version: 3.0.0.beta
- rails: 
    version: 3.0.0.beta
- tzinfo: 
    version: 0.3.16
- activesupport: 
    version: 3.0.0.beta
hash: b75772b5511703b25aded771d7ca687836679fef
sources: 
- Rubygems: 
    uri: http://gemcutter.org
- Path: 
    glob: "{*/,}*.gemspec"
    path: /Users/mikel/rails_programs/rails
```

A couple of things to notice about this, see that the `pg` gem has now
been locked to version 0.8.0? This means that your application will now
ONLY start if it has access to this version, of course, if the target
platform does not have version 0.8.0 installed, a simple
`bundle install` will fix this.

The `Gemfile.lock` also has a hash in it, this is a SHA of your Gemfile,
this is there so that if you change your Gemfile to add a new gem, say
`hpricot`, then bundler will complain (rightly so) as follows:

``` shell
 $ bundle check
You changed your Gemfile after locking. Please relock using `bundle lock`
```

OK, so we run bundle lock again:

``` shell
 $ bundle lock
The bundle is already locked, relocking.
Could not find gem 'hpricot (= 0.6, runtime)' in any of the sources.
Run `bundle install` to install missing gems
```

Well, good, I like being lead by the hand...

``` shell
 $ bundle install
Fetching source index from http://gemcutter.org
Resolving dependencies
Installing abstract (1.0.0) from .gem files at /Users/mikel/Code/app/vendor/cache 
Installing actionmailer (3.0.0.beta) from .gem files at /Users/mikel/Code/app/vendor/cache 
Installing actionpack (3.0.0.beta) from .gem files at /Users/mikel/Code/app/vendor/cache 
Installing activemodel (3.0.0.beta) from .gem files at /Users/mikel/Code/app/vendor/cache 
Installing activerecord (3.0.0.beta) from .gem files at /Users/mikel/Code/app/vendor/cache 
Installing activeresource (3.0.0.beta) from .gem files at /Users/mikel/Code/app/vendor/cache 
Installing activesupport (3.0.0.beta) from .gem files at /Users/mikel/Code/app/vendor/cache 
Installing arel (0.2.1) from .gem files at /Users/mikel/Code/app/vendor/cache 
Installing builder (2.1.2) from .gem files at /Users/mikel/Code/app/vendor/cache 
Installing bundler (0.9.3) from system gems 
Installing erubis (2.6.5) from .gem files at /Users/mikel/Code/app/vendor/cache 
Installing hpricot (0.6) from rubygems repository at http://gemcutter.org with native extensions 
Installing i18n (0.3.3) from .gem files at /Users/mikel/Code/app/vendor/cache 
Installing mail (2.1.2) from .gem files at /Users/mikel/Code/app/vendor/cache 
Installing memcache-client (1.7.8) from .gem files at /Users/mikel/Code/app/vendor/cache 
Installing mime-types (1.16) from .gem files at /Users/mikel/Code/app/vendor/cache 
Installing pg (0.8.0) from system gems 
Installing rack (1.1.0) from .gem files at /Users/mikel/Code/app/vendor/cache 
Installing rack-mount (0.4.5) from .gem files at /Users/mikel/Code/app/vendor/cache 
Installing rack-test (0.5.3) from .gem files at /Users/mikel/Code/app/vendor/cache 
Installing rails (3.0.0.beta) from .gem files at /Users/mikel/Code/app/vendor/cache 
Installing railties (3.0.0.beta) from .gem files at /Users/mikel/Code/app/vendor/cache 
Installing rake (0.8.7) from .gem files at /Users/mikel/Code/app/vendor/cache 
Installing sqlite3-ruby (1.2.5) from .gem files at /Users/mikel/Code/app/vendor/cache with native extensions 
Installing text-format (1.0.0) from .gem files at /Users/mikel/Code/app/vendor/cache 
Installing text-hyphen (1.0.0) from .gem files at /Users/mikel/Code/app/vendor/cache 
Installing thor (0.13.0) from .gem files at /Users/mikel/Code/app/vendor/cache 
Installing tzinfo (0.3.16) from .gem files at /Users/mikel/Code/app/vendor/cache 
Your bundle is complete!
```

Good, see bundler did what it was meant to and grabbed the `hpricot` gem
for us. Mow that we have installed, lets bundle check again:

``` shell
 $ bundle check
The Gemfile's dependencies are satisfied
```

All good, so now we can bundle pack (which is optional as you can just
lock off the system gems installed):

``` shell
 $ bundle pack
Copying .gem files into vendor/cache
  * text-hyphen-1.0.0.gem
  * hpricot-0.6.gem
  * builder-2.1.2.gem
  * i18n-0.3.3.gem
  * bundler-0.9.3.gem
  * arel-0.2.1.gem
  * activemodel-3.0.0.beta.gem
  * mime-types-1.16.gem
  * mail-2.1.2.gem
  * abstract-1.0.0.gem
  * erubis-2.6.5.gem
  * thor-0.13.0.gem
  * sqlite3-ruby-1.2.5.gem
  * rake-0.8.7.gem
  * railties-3.0.0.beta.gem
  * memcache-client-1.7.8.gem
  * rack-1.1.0.gem
  * rack-test-0.5.3.gem
  * rack-mount-0.4.5.gem
  * actionpack-3.0.0.beta.gem
  * pg-0.8.0.gem
  * activerecord-3.0.0.beta.gem
  * text-format-1.0.0.gem
  * actionmailer-3.0.0.beta.gem
  * activeresource-3.0.0.beta.gem
  * rails-3.0.0.beta.gem
  * tzinfo-0.3.16.gem
  * activesupport-3.0.0.beta.gem
```

Awesome, hpricot was packed. Now we can bundle lock:

``` shell
 $ bundle lock
The bundle is now locked. Use `bundle show` to list the gems in the environment.
```

The app is now all good and ready to deploy again.

If you look at the Gemfile.lock file, you will find the hash has changed
from before:

``` shell
# Was before:
hash: b75772b5511703b25aded771d7ca687836679fef
#
# Is now:
hash: 613e95d88b2b3e09185c89572cff3291ecaa45cf
```

### Summary

One thing you should remember is that packing and locking your gems with
bundler are optional. You don't have to pack your gems to lock, and you
don't have to lock to install. The point of packing and locking is that
your application becomes a self contained repository of all the gems you
need to run your application.

I hope the above gives you a good introduction to this awesome library
manager.

blogLater

Mikel

