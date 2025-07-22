---
title: "Installing RSpec for Rails 3"
author: Mikel Lindsaar
date: 2010-04-14
layout: home
redirect_from:
  - /2010/4/14/installing_rspec_for_rails_3
---
Installing RSpec for Rails 3 was quite simple, here is a short guide to
make sure you can also do it :)

For a Rails 3 app, simply edit the Gemfile and put this into the test
section:

``` ruby
group :test do
  gem "rspec-rails",      ">= 2.0.0.beta"
  gem "autotest"
  gem "autotest-rails"
end
```

Then from your Rails root do:

``` shell
$ bundle install
```

Once installed, you will need to tell RSpec to install itself:

``` shell
 $ script/rails g rspec:install
       exist  lib
      create  lib/tasks/rspec.rake
       exist  config/initializers
      create  config/initializers/rspec_generator.rb
       exist  spec
      create  spec/spec_helper.rb
      create  autotest
      create  autotest/discover.rb
```

Then you should just be able to run Autotest:

``` shell
 $ autotest
loading autotest/rails_rspec2
style: RailsRspec2
/Users/mikel/.rvm/rubies/ruby-1.8.7-p249/bin/ruby <snip>
........

Finished in 0.30205 seconds
8 examples, 0 failures
```

Nice.

blogLater

Mikel
