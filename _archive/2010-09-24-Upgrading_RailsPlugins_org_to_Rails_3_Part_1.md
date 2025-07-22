---
title: "Upgrading RailsPlugins.org to Rails 3 - Part 1"
author: Mikel Lindsaar
date: 2010-09-24
layout: home
redirect_from:
  - /2010/9/27/Upgrading_RailsPlugins_org_to_Rails_3_Part_1
  - /2010/5/18/Upgrading_RailsPlugins_org_to_Rails_3_Part_1
  - /2010/5/18/Upgrading_RailsPlugins_org_to_Rails_3_Part_1
---
Note, this post has been recreated now that Rails 3 has been released.
Please see: [Updating Railsplugins.org to Rails
3](/2010/9/24/updating_railsplugins_org_to_rails_3_part_1)

### New version available

Please see the above new version, the below is old content and not
really usable any more

### Old content:

I am going to do a series of blog posts covering the upgrade of
RailsPlugins.org to Rails 3. You can follow along as we go and comments
or suggestions are welcome!

This upgrade was done using at least Rails 3 beta3. If try it on
anything earlier, it will most likely go boom.

### Process

Going about upgrading a non trivial site like RailsPlugins.org requires
a process to make sure it works:

1.  Confirm the gems and plugins you are using either work with Rails 3,
    there are alternatives you can use, or you are interested in helping
    upgrade them - this is the most important step in terms of scope and
    time required to get the job done.
2.  Run all specs and features or tests and make sure they pass - if you
    don't have any, then now would be a good time to install Cucumber
    and write at *least* features covering all the main user stories of
    your site.
3.  Run the rails_upgrade plugin to highlight areas of concern
4.  Upgrade the application to Rails 3
5.  Fix all concerns within your application itself, ignoring plugins
    for now
6.  Go through each plugin and gem, either installing newer versions
    that are Rails 3 compatible, or replacing / fixing them
7.  Run all specs and features and tests and make sure they pass
8.  Boot up and play around in your development environment
9.  Deploy on a staging environment to confirm your upgrade
10. Deploy live and watch like a hawk.

I am going to document all these steps as part of upgrading the
RailsPlugins.org site.

### Confirm the gems and plugins you are using

Going through all the plugins and gems we use on the RailsPlugins.org
site, showed up that most of them have Rails 3 versions available or
listed as "Maybe". I guess I'll be helping people get it done! :)

### Run all specs and features

I have good coverage on RailsPlugins.org and it is all green... so
onward and upwards.

### Run the upgrade plugin

The rails_upgrade plugin is hosted on github and up to date with all the
latest bells and whistles of Rails 3, so we'll use that:

``` shell
$ script/plugin install git://github.com/rails/rails_upgrade.git
```

And then once installed, we do:

``` shell
$ rake rails:upgrade:check
```

Which gives us *pages* of output, simplified down to:

``` shell
Deprecated constant(s)
Constants like RAILS_ENV, RAILS_ROOT, and RAILS_DEFAULT_LOGGER are now deprecated.
More information: http://litanyagainstfear.com/blog/2010/02/03/the-rails-module/
...

Deprecated session secret setting
Previously, session secret was set directly on ActionController::Base; it's now config.secret_token.
More information: http://weblog.rubyonrails.org/
...

Old session store setting
Previously, session store was set directly on ActionController::Base; it's now config.session_store :whatever.
More information: http://weblog.rubyonrails.org/
...

Deprecated ActionMailer API
You're using the old ActionMailer API to send e-mails in a controller, model, or observer.
More information: https://lindsaar.net/2010/1/26/new-actionmailer-api-in-rails-3
...

Old ActionMailer class API
You're using the old API in a mailer class.
More information: https://lindsaar.net/2010/1/26/new-actionmailer-api-in-rails-3
...

Soon-to-be-deprecated ActiveRecord calls
Methods such as find(:all), find(:first), finds with conditions, and the :joins option will soon be deprecated.
More information: http://m.onkey.org/2010/1/22/active-record-query-interface
...

named_scope is now just scope
The named_scope method has been renamed to just scope.
More information: http://github.com/rails/rails/commit/d60bb0a9e4be2ac0a9de9a69041a4ddc2e0cc914
...

Old Rails generator API
A plugin in the app is using the old generator API (a new one may be available at http://github.com/trydionel/rails3-generators).
More information: http://blog.plataformatec.com.br/2010/01/discovering-rails-3-generators/
...

Old router API
The router API has totally changed.
More information: http://yehudakatz.com/2009/12/26/the-rails-3-router-rack-it-up/
...

Deprecated ERb helper calls
Block helpers that use concat (e.g., form_for) should use <%= instead of <%. The current form will continue to work for now, but you will get deprecation warnings since this form will go away in the future.
More information: http://weblog.rubyonrails.org/
...

New file needed: config/application.rb
You need to add a config/application.rb.
More information: http://omgbloglol.com/post/353978923/the-path-to-rails-3-approaching-the-upgrade
...
```

OK, so this might be too long for a single blog post, let's take it in
sections then.

### Deprecated constant(s)

This section produced the following output:

``` shell
Deprecated constant(s)
Constants like RAILS_ENV, RAILS_ROOT, and RAILS_DEFAULT_LOGGER are now deprecated.
More information: http://litanyagainstfear.com/blog/2010/02/03/the-rails-module/

The culprits:
  - /Users/mikel/Code/railsplugins/lib/tasks/environments.rake
  - /Users/mikel/Code/railsplugins/lib/tasks/cucumber.rake
  - /Users/mikel/Code/railsplugins/lib/tasks/hoptoad_notifier_tasks.rake
  - /Users/mikel/Code/railsplugins/lib/tasks/rspec.rake
```

Which doesn't seem too bad. I only really have one file in my
application that is to blame, environments.rake, the other three are
part of plugins that RailsPlugins.org uses, and I trust that the Rails 3
versions of these which we will update to later, should handle
themselves.

Opening up environments.rake we see:

``` shell
# Sets environments as needed for rake tasks
%w[development production staging].each do |env|
  desc "Runs the following task in the #{env} environment"
  task env do
    RAILS_ENV = ENV['RAILS_ENV'] = env
  end
end

task :testing do
  Rake::Task["test"].invoke
end

task :dev do
  Rake::Task["development"].invoke
end

task :prod do
  Rake::Task["production"].invoke
end
```

This is a custom rake file we use to easily set environments for rake
tasks. However, setting `RAILS_ENV` is deprecated in Rails 3. In Rails
3, you can set `Rails.env` directly with an assignment. So changing this
rake task to be Rails 3 compatible would be:

``` shell
# Sets environments as needed for rake tasks
%w[development production staging].each do |env|
  desc "Runs the following task in the #{env} environment"
  task env do
    Rails.env = env
  end
end

task :testing do
  Rake::Task["test"].invoke
end

task :dev do
  Rake::Task["development"].invoke
end

task :prod do
  Rake::Task["production"].invoke
end
```

OK good. As I mentioned above, we are going to eave the cucumber, rspec
and hoptoad files to be updated by their respective gems as we move
along.

### Deprecated session secret setting

The rails_upgrade plugin has pointed out the following:

``` shell
Deprecated session secret setting
Previously, session secret was set directly on ActionController::Base; it's now config.secret_token.
More information: http://weblog.rubyonrails.org/

The culprits:
    - /Users/mikel/Code/railsplugins/config/initializers/session_store.rb

Old session store setting
Previously, session store was set directly on ActionController::Base; it's now config.session_store :whatever.
More information: http://weblog.rubyonrails.org/

The culprits:
  - /Users/mikel/Code/railsplugins/config/initializers/session_store.rb
```

Which looks like this:

`config/initializers/session_store.rb`

``` ruby
ActionController::Base.session = {
  :key         => '_plugins_session',
  :secret      => 'somereallylongrandomkey'
}
```

In Rails 3, this process was changed quite significantly, with this
commit, the upgrade though is very straight forward. First, you reduce
`session_store.rb` to the following:

``` ruby
Rails.application.config.session_store :cookie_store, :key => "_my_app_name_session"
```

And then, because we now need somewhere to store the secret, you create
a new file called `config/initializers/cookie_verification_secret.rb`
and put inside of it:

``` ruby
Rails.application.config.cookie_secret = 'somereallylongrandomkey'
```

If instead of using cookies, you were using active record as the store,
then you obviously wouldn't need the `cookie_verification_secret.rb`
file and instead would insert any other config you needed into its own
file inside of initializers.

This gives us the added bonus of being able to exclude cookie secrets
from source control systems.

In the next instalment, we'll cover getting the RailsPlugins.org site
actually up and running on Rails 3.

blogLater

Mikel
