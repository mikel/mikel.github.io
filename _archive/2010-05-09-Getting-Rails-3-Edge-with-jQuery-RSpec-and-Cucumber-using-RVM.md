---
title: "Getting Rails 3 Edge with jQuery, RSpec and Cucumber using RVM "
author: Mikel Lindsaar
date: 2010-05-09
layout: home
redirect_from:
  - /2010/5/9/Getting-Rails-3-Edge-with-jQuery-RSpec-and-Cucumber-using-RVM
---
Here are the simple (?) steps to get Rails 3 running with the above
technologies.

### Install Rails

You know, this is pretty obvious, but before you get into any other hoo
ha you are going to have to get a version of Rails installed into your
system gems so that you will have access to the `rails` command.

So:

``` {.shell lang="shell" data-caption="installing Rails 3"}
$ gem install rails --version "3.0.0.beta3"
Successfully installed i18n-0.3.7
Successfully installed tzinfo-0.3.20
Successfully installed builder-2.1.2
Successfully installed memcache-client-1.8.3
Successfully installed activesupport-3.0.0.beta3
Successfully installed activemodel-3.0.0.beta3
....
```

Should do the trick.

### Setup the Rails app

Now we have Rails install our app using the standard `rails g` command.

``` {.shell lang="shell" data-caption="creating an app"}
$ rails my_app -JT
     create
     create  README
     create  .gitignore
     create  Rakefile
     create  config.ru
     create  Gemfile
     ....
```

The `-J` parameter, tells Rails not to install the Prototype Javascript
libraries. The `-T` tells it to skip generating the `Test::Unit` files,
together they order [Cheese
Royals](http://www.youtube.com/watch?v=SLtwFugudZE)

### Setting up RVM

Now change into the my_app directory and add the line
`rvm ruby-1.8.7@my_app` to the `.rvmrc file`

``` {.shell lang="shell" data-caption="making an RVMRC file"}
$ echo "rvm ruby-1.8.7@my_app" > .rvmrc
```

This will make a clean gemset for our Rails app to play in.

But we need to create the gemset first:

``` {.shell lang="shell" data-caption="making the gemset"}
$ rvm gemset create 'my_app'
Gemset 'my_app' created.
```

Nice.

Now whenever we `cd` into the `my_app` directory, RVM will auto detect
the `.rvmrc` file and switch our gemset to the `my_app` Gemset.

Or we can do it manually:

``` {.shell lang="shell" data-caption="changing gemsets manually"}
$ rvm ruby-1.8.7@my_app
$ gem list

*** LOCAL GEMS ***

rake (0.8.7)
```

Awesome.

### House Keeping

``` {.shell lang="shell" data-caption="cleaning up the app"}
$ cd my_app/
$ rm public/index.html
$ rm public/images/rails.png
```

Notice I deleted the `index.html` and `rails.png` above. You don't

*have* to do this right now, if you want to see the nice happy message
telling you that daisies are going to bloom and butterflies are
fluttering about because your Rails App is now working, please don't
remove it yet, wait and fire up your rails app with `rails s` and browse
to `http://127.0.0.1:3000` and bask in your RailsFuNess...

But for the rest of us, nuke it.

### Getting jQuery installed

Next, we need to install jQuery. Just go to the website and download it
and place it into your javascripts directory. For cut and fiends out
there, this curl command should handle it as well:

``` {.shell lang="shell" data-caption="downloading jQuery"}
$ mkdir public/javascripts/jquery
$ curl http://code.jquery.com/jquery-1.4.2.min.js > public/javascripts/jquery/jquery-1.4.2.min.js
```

Note I have put this into a jQuery folder. I have done this so that the
`javascript_include_tag :all` command I will use further down does not
pickup the jQuery source files.

### Getting the Rails jQuery Driver

Now that we have destroyed prototype, we need to replace it with jQuery,
two steps to this.

First, download the jQuery driver and over write your `rails.js` file
that lives in `public/javascripts/`, I usually do this by going to the
[Rails
jQuery-UJS](http://github.com/rails/jquery-ujs/blob/master/src/rails.js)
page and clicking raw and cut and pasting it into the
`public/javascripts/rails.js` file. Feel free to use a submodule if you
wish, or

``` {.shell lang="shell" data-caption="installing the jQuery driver"}
$ curl http://github.com/rails/jquery-ujs/raw/59dd91d945570391f905b1e40444e5921dbc2b8f/src/rails.js > public/javascripts/rails.js
```

Will do it as well... note, this will most likely *not* be the most
recent version in the future. To get the latest, go to the [Rails
jQuery-UJS](http://github.com/rails/jquery-ujs/blob/master/src/rails.js)
page and click on the RAW link to the right of the source code div.

### Wiring up jQuery and the Rails driver

Now that we have jQuery and the Rails jQuery UJS drivers installed, we
need to wire them up to the app, so open up
`app/views/layouts/application.html.erb` make it look like the
following:

``` {.ruby lang="erb" data-caption="adding jQuery and rails.js"}
<!DOCTYPE html>
<html>
<head>
  <title>MyApp</title>
  <%= stylesheet_link_tag :all %>
  <%= csrf_meta_tag %>
</head>
<body>

<%= yield %>

<%= javascript_include_tag 'jquery/jquery-1.4.2.min' %>
<%= javascript_include_tag :all, :cache => true %>
</body>
</html>
```

OK, couple of things here. Firstly, we remove the
`javascript_include_tag :all` from the header. Then we put the two tags
at the bottom of the document.

Why do we separate out the `jquery/jquery-1.4.2.min` from the
`javascript_include_tag :all` line? This is because the `:all` directive
will just grab all the javascript files in the order it finds them and
bundle them all together, which means that your javascript files, may be
trying to init javascript classes from your jQuery library that do not
exist yet.

So we get around this by loading jQuery first.

OK. So that is jQuery sorted, now onto the specifications side.

### Installing RSpec & Friends

Best way to go about this, is to modify your `Gemfile` and make it look
something like this:

``` {.ruby lang="ruby" data-caption="Gemfile"}
source 'http://rubygems.org'

## Bundle edge rails:
gem "rails",  :git => "git://github.com/rails/rails.git"
gem "sqlite3-ruby"

group :test do
  gem "rspec"
  gem "rspec-rails",      ">= 2.0.0.beta"
  gem "machinist",        :git => "git://github.com/notahat/machinist.git"
  gem "faker"
  gem "ZenTest"
  gem "autotest"
  gem "autotest-rails"
  gem "cucumber",         :git => "git://github.com/aslakhellesoy/cucumber.git"
  gem "database_cleaner", :git => 'git://github.com/bmabey/database_cleaner.git'
  gem "cucumber-rails",   :git => "git://github.com/aslakhellesoy/cucumber-rails.git"
  gem "capybara"
  gem "capybara-envjs"
  gem "launchy"
  gem "ruby-debug"
end
```

This is going to install everything you need to get RSpec, Cucumber,
Machinist, autotest and even throwing in the Ruby Debugger at the
bottom.

Save this, and then we need to install it. But remember, we are on a
clean gemset, so we need to install bundler first:

``` {.shell lang="shell" data-caption="installing bundler"}
 $ gem install bundler
Successfully installed bundler-0.9.25
1 gem installed
Installing ri documentation for bundler-0.9.25...
Installing RDoc documentation for bundler-0.9.25...

mikel@baci.lindsaar.net ~/Code/my_app
 $ gem list

*** LOCAL GEMS ***

bundler (0.9.25)
rake (0.8.7)
```

Good to go, so now we are just a `bundle install` away from launching:

``` {.shell lang="shell" data-caption="bundle installing"}
 $ bundle install
Fetching source index from http://rubygems.org/
Using rake (0.8.7) from system gems
Installing abstract (1.0.0) from .gem files at /Users/mikel/.rvm/gems/ruby-1.8.7-p249@my_app/cache
...
```

And we are away!

### Initializing RSpec and Cucumber

Now that we have all our dependencies done, we need to tell RSpec and
Cucumber to get a move on:

``` {.shell lang="shell" data-caption="initialising RSpec"}
$ rails g rspec:install
      exist  lib
     create  lib/tasks/rspec.rake
      exist  config/initializers
     create  config/initializers/rspec_generator.rb
     create  spec
     create  spec/spec_helper.rb
     create  autotest
     create  autotest/discover.rb
```

And then for cucumber, we will use capybara (because we installed it in
the Gemfile above) and pass `--rspec` because I like being complete!

``` {.shell lang="shell" data-caption="initialising Cucumber"}
$ rails g cucumber:skeleton --capybara --rspec
     create  config/cucumber.yml
     create  script/cucumber
      chmod  script/cucumber
     create  features/step_definitions
     create  features/step_definitions/web_steps.rb
     create  features/support
     create  features/support/paths.rb
     create  features/support/env.rb
      exist  lib/tasks
     create  lib/tasks/cucumber.rake
       gsub  config/database.yml
       gsub  config/database.yml
      force  config/database.yml
```

OK good.. so that is our skeleton app.

One last thing, we are using Rails with sqlite, so it will expect our
databases to exist before it will run any tests, so let's make them:

``` {.shell lang="shell" data-caption="making databases"}
$ rake db:create
```

### Getting our first feature to run

Now that we have our app installed and everything wired up, we should be
able to get an initial feature working, so go ahead and make a
`features/the_home_page.feature` file, and whack something like this in
it:

``` {.fixed lang="fixed" data-caption="features/the_home_page.feature"}
Feature: Manage app_should_boots
  In order to see what my app is about
  a user
  wants to be able to land on a home page

  Scenario: Visiting the site for the first time
    Given I am on the home page
    Then I should see "Welcome" within "h1"
```

This should fail:

``` {.shell lang="shell" data-caption=""}
Using the default profile...
.F

(::) failed steps (::)

scope '//h1' not found on page (Capybara::ElementNotFound)
./features/step_definitions/web_steps.rb:14:in `with_scope'
./features/step_definitions/web_steps.rb:108:in `/^(?:|I )should see "([^\"]*)"(?: within "([^\"]*)")?$/'
features/the_home_page.feature:8:in `Then I should see "Welcome" within "h1"'

Failing Scenarios:
cucumber features/the_home_page.feature:6 # Scenario: Visiting the site for the first time
```

Which is saying that the default rails "Not Found" page does not have
"Welcome" within a "h1" tag... which I guess is true!

Lets fix this:

First we'll generate the welcome controller:

``` {.shell lang="shell" data-caption="generate welcome controller"}
$ rails g controller welcome
     create  app/controllers/welcome_controller.rb
     invoke  erb
     create    app/views/welcome
     invoke  rspec
     create    spec/controllers/welcome_controller_spec.rb
     create    spec/views/welcome
     invoke  helper
     create    app/helpers/welcome_helper.rb
     invoke    rspec
```

Then we'll edit the `config/routes.rb` file to wire up the root url to
the welcome controllers index action:

``` {.ruby lang="ruby" data-caption="config/routes.rb"}
MyApp::Application.routes.draw do |map|
  root :to => "welcome#index"
end
```

Note, if you haven't already deleted the `public/index.html` file, now
is a good time to do it!

Now we make an `app/views/welcome/index.html.erb` file and put in it our
welcome message:

``` {.ruby lang="erb" data-caption="app/views/welcome/index.html.erb"}
<h1>Welcome</h1>
```

And now we will re-run our cucumber feature and all should be good:

``` {.shell lang="shell" data-caption="cucumber feature output"}
 $ rake cucumber
Using the default profile...
..

1 scenario (1 passed)
2 steps (2 passed)
0m0.214s
```

Cool! We are now on the Rails with Cucumber and everything else that is
good in the world.

Enjoy!

blogLater

Mikel
