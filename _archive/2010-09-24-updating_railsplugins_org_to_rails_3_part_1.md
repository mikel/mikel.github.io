---
title: "Updating RailsPlugins.org to Rails 3 - Part 1"
author: Mikel Lindsaar
date: 2010-09-24
layout: post
redirect_from:
  - /2010/9/24/updating_railsplugins_org_to_rails_3_part_1
---
[RubyX](http://rubyx.com) are the maintainers for the
[RailsPlugins.org](http://railsplugins.org) website with hosting kindly
donated by [EngineYard](http://engineyard.com). As the site is all about
compatibility with Rails 3, the irony was not lost on us that the site
is running on Rails 2.3.5. I will do a series of posts which cover how
we updated the site to Rails 3.

First off, RailsPlugins.org is a non trivial web application. It has
OpenID authentication, API integration with RubyGems.org as well as a
complex versioning, voting and commenting system that includes emails
out to gem owners to encourage them to get their gems up to date with
Rails 3.

The site currently hosts information for over 500 plugins and gems,
tracking 1,500 versions with over 6,500 opinions from users and owners
alike.

First off, it is good to work out a broad process on how you plan to
upgrade a Rails 2.x app to Rails 3. At RubyX, this is one of our
specialties, and so we have a documented path on how we go about it.

### RubyX Rails 3 Upgrade Process from Rails 2.3.x

As I mentioned, RubyX have a codified path on how we update Rails 2.3
apps to Rails 3. If you are running a version of rails that is earlier
than Rails 2.3, you really need to update to 2.3.x first before trying
to go to Rails 3. It will save you a lot of pain.

1.  Confirm all specs, tests and features are passing
2.  Migrate the 2.3.x app over to using Bundler and a Gemfile
3.  Remove all vendor'd gems and plugins that can be specified in the
    Gemfile
4.  Audit any remaining vendor'd gems and plugins that have application
    specific modifications, and fork these changes into our own
    repositories and install them from here using the Gemfile
5.  Review all gems and plugins in use by the app and ensure that Rails
    3 versions are available.
6.  For any remaining vendor'd gems and plugins that can not be
    Gemfile'd now but do have a Rails 3 version, leave them vendor'd for
    now and migrate to the gem version once we have updated t Rails 3.
7.  For any gems that do not have a Rails 3 version, decide what to do.
    Contribute a Rails 3 version or replace.
8.  Deploy this code to staging environment, for a sanity check.
9.  Migrate the Rails app release by release up to Rails 2.3.9
10. Handle all deprecation warnings at each release
11. Migrate Gemfile and app to Rails 3
12. Update gem dependencies to ensure working with Rails 3
13. Do minimal modifications required to get all tests and specs passing
14. Review application code and take advantage of new Rails 3 idioms
15. Deploy to cloned production environment and test fully
16. Deploy to production environment with roll back plan
17. Test
18. Test
19. Test

Obviously the above gets run in a separate branch, it also gets done as
rapidly as possible to avoid divergence with the production branch.
There are several opportunities to merge back into production, at each
update of Rails before 3.0 for example. However, this is not required.

A key point is step 6, making sure you have Rails 3 compatible versions
of all gems you use in the app. This can obviously be done earlier,
however, upgrading to Rails 2.3.9 is a good thing to do in any case and
can be the first goal of your migration process.

You can use RailsPlugins.org to look up your gems and plugins to see
what other users have found and authors have commented on in relation to
Rails 3 compatibility.

So with the process codified. Lets get onto our first step, making sure
the app has test coverage.

### Confirm all specs, tests and features are passing

In doing this sort of upgrade you really can't stress a good test suite
enough. RailsPlugins has XXXX specs and XXXX features that exercise
every part of the application, very thoroughly. So before we start
changing code or files, lets run that suite:

``` shell
$ rake spec
  .................... (...)
  Finished in 20.469918 seconds
  234 examples, 0 failures
$ rake cucumber
  .................... (...)
  126 scenarios (126 passed)
  1873 steps (1873 passed)
  1m7.546s
```

OK, it could be a lot faster, but we have the green light on all our
specs and features. Time to migrate the app to use Bundler and a
Gemfile.

### Migrate the 2.3.x app to use Bundler and a Gemfile

Now that we have spec coverage for our changes, the next thing we need
to do on a Rails 2.3 app is to create a `config/preinitializer.rb` file
as well as update your `config/boot.rb` to boot using Bundler. This is
well explained on the [Bundler](http://gembundler.com) website. Just
follow along there.

In the case of RailsPlugins.org, we were already used a Gemfile, of
sorts. It was running a 0.9 release of bundler, and the Gemfile looked
like this:

``` ruby
source :gemcutter

gem 'rails', '2.3.5'

gem 'mysql',                '2.8.1'
gem 'url_field',            '0.0.2'
gem 'ruby-openid'
gem 'hoptoad_notifier'
gem 'capistrano'
gem 'engineyard',           '1.1.3'
gem 'delayed_job',          '2.0.2'

group :plugins do
  gem 'authlogic-oid',       :require => 'authlogic_openid'
  gem 'authlogic',           '2.1.3'
  gem 'behavior',            '0.2.0'
  gem 'will_paginate',       '2.3.11'
  gem 'inherited_resources', '1.0.4'
end

group :test do
  gem 'highline',            '~> 1.5.2'
  gem 'machinist',           '>=1.0.3'
  gem 'cucumber',            '>=0.3.103'
  gem 'cucumber-rails',      '>=0.2.4'
  gem 'database_cleaner',    '>=0.4.3'
  gem 'webrat',              '>=0.6.0'
  gem 'rspec',               '>=1.3.0'
  gem 'rspec-rails',         '>=1.3.2'
  gem 'rspec',               '>=1.2.9'
  gem 'faker',               '~>0.3.1'
  gem 'nokogiri'
  gem 'ruby-debug'
  gem 'ZenTest'
end
```

The above Gemfile is not TOO bad, but there are some three glaring
mistakes.

Firstly is the use of "\>=" While this is limited to the test group, it
is also just plain not a good idea as it means any equal to or higher
version of the version specified. Using "\~\>" is much safer as it
limits updates to point releases.

Secondly, is the use of the ":plugins" group. This group is there to
make sure that Bundler will check the dependency requirements for this
group when you bundle install, as all of these gems are in the plugins
directory and without any mention in the Gemfile, Bundler would not be
able to check for dependency conflicts.

Thirdly, several production gems requirements have no version attached.
This is dangerous.

So, first thing to do is get version numbers on all of those gems. And
the best way to do that is to log into the production environment and do
a `gem list`.

Doing this found the following versions for the production gems we had
no versions for:

``` ruby
  hoptoad_notifier (2.2.0)
  ruby-openid (2.1.2)
```

Additionally, we no longer use capistrano for deployment, instead
relying on the nice [EngineYard command line
gem](http://www.engineyard.com/blog/2010/engine-yard-cli-now-open-source/)
to handle this.

So we insert those version numbers, and delete capistrano and we get
(without including the test group for now):

``` ruby
source :gemcutter

gem 'rails', '2.3.5'

gem 'mysql',                '2.8.1'
gem 'url_field',            '0.0.2'
gem 'ruby-openid',          '2.1.2'
gem 'hoptoad_notifier',     '~> 2.2.0'
gem 'engineyard',           '1.1.3'
gem 'delayed_job',          '2.0.2'

group :plugins do
  gem 'authlogic-oid',       :require => 'authlogic_openid'
  gem 'authlogic',           '2.1.3'
  gem 'behavior',            '0.2.0'
  gem 'will_paginate',       '2.3.11'
  gem 'inherited_resources', '1.0.4'
end
```

With this in place, we do a `bundle install` followed by running our
test suite, to make sure that our changes don't break anything.

With the specs and cukes green, we can commit the above work as the
first step complete.

### Remove all vendor'd gems and plugins that can be specified in the Gemfile

Next step is to get rid of that plugins group, and instead use gems or
github sources directly.

Looking in the vendor/plugins directory of RailsPlugins.org, we see:

``` shell
mikel@mikel.local ~/Code/railsplugins
 $ ls vendor/plugins/
   delayed_job
   formatted-dates
   high_voltage
   hubahuba
   open_id_authentication
   project_search
   timeline_fu
   url_field
```

Sharp eyes will note that we have some duplication between here and the
Gemfile. Lets remove that.

Now doing this is time consuming. The steps are as follows:

1.  Inspect the `vendor/plugins/plugin` directory and see if it has a
    gemspec.\
    \# If there is a gemspec, get the version and create an appropriate
    line in the Gemfile locked to that version\
    \# If no gemspec, search RailsPlugins.org, RubyGems.org or the
    appropriate plugin home page for the right gem version to use for a
    Rails 2.3 app and then put this in the Gemfile\
    \# If no gemspec and no gem released, skip and go to the next one.
2.  Once the gemfile has the right version, remove the vendor/plugins
    directory entirely
3.  Check the various environment.rb files (main, production,
    development, testing etc) and remove any `config.gem` line that
    relates to this gem. Use any information gleaned here to update the
    Gemfile line
4.  Do a new bundle install
5.  Run all specs or tests and cukes again and make sure you are still
    green
6.  Handle any requirement errors or coding errors (if doing this has
    forced you onto a different incompatible gem version)
7.  Once all specs and cukes are green, repeat with the next directory.

The above can take time.

In our case, we had a few situations.

a\) We had a pluginized version of hubahuba, but in the entire app, this
plugin was used ONCE. So instead, I removed the code we were using and
made a `lib/file` that implemented the code we needed and just nuked the
directory. Less code is good.

b\) We were not using project_search any more. So this got the boot.

c\) high_voltage is a gem, but that Gem only works on Rails 3. As I know
that the Rails 3 version is available we will leave it vendor'd for now
as there is no point doing anything else with it.

With all that done, our Gemfile looked like this:

``` ruby
source :rubygems

gem 'rails',                '2.3.5'

gem 'mysql',                '~> 2.8.1'
gem 'url_field',            '~> 0.0.2'
gem 'ruby-openid',          '~> 2.1.7'
gem 'rack-openid',          '~> 1.0.3'
gem 'hoptoad_notifier',     '~> 2.2.5'
gem 'engineyard'
gem 'will_paginate',        '~> 2.3.11'
gem 'delayed_job',          '~> 2.0.0'
gem 'authlogic',            '2.1.3'
gem 'behavior',             '~> 0.2.0'
gem 'inherited_resources',  '~> 1.0.4'
gem 'formatted-dates',      '~> 0.0.1'
gem 'timeline_fu',          '~> 0.3.0'

group :test do
  gem 'ZenTest'
  gem 'highline',           '~> 1.5.2'
  gem 'machinist',          '>=1.0.3'
  gem 'cucumber',           '>=0.3.103'
  gem 'cucumber-rails',     '>=0.2.4'
  gem 'database_cleaner',   '>=0.4.3'
  gem 'webrat',             '>=0.6.0'
  gem 'rspec',              '>=1.3.0'
  gem 'rspec-rails',        '>=1.3.2'
  gem 'faker',              '~>0.3.1'
  gem 'nokogiri'
  gem 'ruby-debug'
end
```

With only high_voltage left in `vendor/plugins` from the original bunch.

However, I needed to add in `open_id_authentication` and a fork of
`authlogic_openid` to get OpenID working again. Looking through the
various codes, it looks like authlogic has some issues with OpenID at
the moment, so part of the Rails 3 update may be converting to Devise.

Note also how I changed the requirements to be "\~\>" instead of locked
at a version. If you do this, run `bundle update` once and run all your
specs again to make sure everything passes. Then commit your
Gemfile.lock to your source control so the same version gets deployed on
your production environment.

### Deploy this code to staging environment, for a sanity check.

Next step is to deploy our new Gemfile based Rails app to a staging
environment. On EngineYard this is painfully easy to do, simply snapshot
your production environment, and then clone it to a new name (staging).
Once done, boot up your app and do an `ey deploy -e staging`. For other
hosts, I am sure you will know how to do this as well.

We ran into a problem in doing this. Our production RubyGems.org was
still running on 1.8.6 and there was a gem requiring Ruby 1.8.7 as a
minimum. So we updated our Ruby version to 1.8.7 and tried again. Due to
this we now know that we will have to update our production environment
to 1.8.7, so I scheduled a time to do this on the website, which gave me
a good opportunity to use the new sites feature from
[tellthemwhen.com](http://tellthemwhen.com)

This is what our command line deploy looks like:

``` shell
 $ ey deploy -e staging
Beginning deploy for 'railsplugins' in 'staging' on server...
Successfully installed engineyard-serverside-1.3.3
1 gem installed
~> Deploying revision e94f047... Removing project_search, don't need that
~> Pushing code to all servers
~> Starting full deploy
~> Copying to /data/railsplugins/releases/20100923133736
~> Ensuring proper ownership
~> Gemfile detected, bundling gems
~> Symlinking configs
~> Migrating: cd /data/railsplugins/releases/20100923133736 && PATH=/data/railsplugins/releases/20100923133736/ey_bundler_binstubs:$PATH RAILS_ENV=production RACK_ENV=production MERB_ENV=production rake db:migrate --trace
~> Symlinking code
~> Restarting app servers
~> Cleaning up old releases
Deploy complete
```

Now the staging environment deployed and tested OK, it's time to update
the production site during the scheduled maintenance window and then
move onto the next step, Migrate the Rails app release by release up to
Rails 2.3.9.

For that, I will leave until the next post.

blogLater

Mikel Lindsaar

