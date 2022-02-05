---
title: "Bundler - uninitialized constant ActionController "
author: Mikel Lindsaar
date: 2010-04-01
layout: post
redirect_from:
  - /2010/4/1/bundler_uninitialized_constant_ActionController
---
If you are switching over a Rails 2.3 app to Bundler with a Rails App,
or you are setting up a new one, you might run into this error when you
try to boot rails or run a rake task, thankfully the solution is simple.

The problem is that in your Gemfile, you are trying to load a gem that
requires the Rails stack to be in place. If you check out the Bundler
docs for [Rails 2.3](http://gembundler.com/rails23.html) you will see a
`:plugins` group option. This group provides a way to load up gem
plugins that require the Rails stack.

If you are not sure which gem is requiring the Rails stack before Rails
is loaded and thus blowing out bundler, you can run `rake -T` as usual,
you will get something like this:

``` shell
 $ rake -T --trace
(in /Users/mikel/Code/railsplugins)
rake aborted!
uninitialized constant ActionController
/Users/mikel/.rvm/gems/ruby-1.8.7-p249@railsplugins/gems/activesupport-2.3.5/lib/active_support/dependencies.rb:443:in `load_missing_constant'
/Users/mikel/.rvm/gems/ruby-1.8.7-p249@railsplugins/gems/activesupport-2.3.5/lib/active_support/dependencies.rb:80:in `const_missing'
/Users/mikel/.rvm/gems/ruby-1.8.7-p249@railsplugins/gems/activesupport-2.3.5/lib/active_support/dependencies.rb:92:in `const_missing'
/Users/mikel/.rvm/gems/ruby-1.8.7-p249@railsplugins/gems/behavior-0.2.0/lib/behavior.rb:80
/Users/mikel/.rvm/gems/ruby-1.8.7-p249@railsplugins/gems/bundler-0.9.14/lib/bundler/runtime.rb:45:in `require'
/Users/mikel/.rvm/gems/ruby-1.8.7-p249@railsplugins/gems/bundler-0.9.14/lib/bundler/runtime.rb:45:in `require'
/Users/mikel/.rvm/gems/ruby-1.8.7-p249@railsplugins/gems/bundler-0.9.14/lib/bundler/runtime.rb:40:in `each'
/Users/mikel/.rvm/gems/ruby-1.8.7-p249@railsplugins/gems/bundler-0.9.14/lib/bundler/runtime.rb:40:in `require'
/Users/mikel/.rvm/gems/ruby-1.8.7-p249@railsplugins/gems/bundler-0.9.14/lib/bundler/runtime.rb:39:in `each'
/Users/mikel/.rvm/gems/ruby-1.8.7-p249@railsplugins/gems/bundler-0.9.14/lib/bundler/runtime.rb:39:in `require'
/Users/mikel/.rvm/gems/ruby-1.8.7-p249@railsplugins/gems/bundler-0.9.14/lib/bundler.rb:75:in `require'
/Users/mikel/Code/railsplugins/config/../config/preinitializer.rb:20
/Users/mikel/Code/railsplugins/config/boot.rb:28:in `load'
/Users/mikel/Code/railsplugins/config/boot.rb:28:in `preinitialize'
/Users/mikel/Code/railsplugins/config/boot.rb:10:in `boot!'
/Users/mikel/Code/railsplugins/config/boot.rb:128
/Users/mikel/.rvm/rubies/ruby-1.8.7-p249/lib/ruby/site_ruby/1.8/rubygems/custom_require.rb:31:in `gem_original_require'
/Users/mikel/.rvm/rubies/ruby-1.8.7-p249/lib/ruby/site_ruby/1.8/rubygems/custom_require.rb:31:in `require'
/Users/mikel/Code/railsplugins/Rakefile:4
/Users/mikel/.rvm/gems/ruby-1.8.7-p249@global/gems/rake-0.8.7/lib/rake.rb:2383:in `load'
/Users/mikel/.rvm/gems/ruby-1.8.7-p249@global/gems/rake-0.8.7/lib/rake.rb:2383:in `raw_load_rakefile'
/Users/mikel/.rvm/gems/ruby-1.8.7-p249@global/gems/rake-0.8.7/lib/rake.rb:2017:in `load_rakefile'
/Users/mikel/.rvm/gems/ruby-1.8.7-p249@global/gems/rake-0.8.7/lib/rake.rb:2068:in `standard_exception_handling'
/Users/mikel/.rvm/gems/ruby-1.8.7-p249@global/gems/rake-0.8.7/lib/rake.rb:2016:in `load_rakefile'
/Users/mikel/.rvm/gems/ruby-1.8.7-p249@global/gems/rake-0.8.7/lib/rake.rb:2000:in `run'
/Users/mikel/.rvm/gems/ruby-1.8.7-p249@global/gems/rake-0.8.7/lib/rake.rb:2068:in `standard_exception_handling'
/Users/mikel/.rvm/gems/ruby-1.8.7-p249@global/gems/rake-0.8.7/lib/rake.rb:1998:in `run'
/Users/mikel/.rvm/gems/ruby-1.8.7-p249@global/gems/rake-0.8.7/bin/rake:31
/Users/mikel/.rvm/gems/ruby-1.8.7-p249@global/bin/rake:19:in `load'
/Users/mikel/.rvm/gems/ruby-1.8.7-p249@global/bin/rake:19
```

Now, inside of that trace is a `<em>`{=html}single line`</em>`{=html}:

``` shell
/Users/mikel/.rvm/gems/ruby-1.8.7-p249@railsplugins/gems/behavior-0.2.0/lib/behavior.rb:80
```

And there is your clue, moving the gem requirement for behavior into the
:plugins group like this:

``` shell
# Gemfile

source :gemcutter

gem 'rails', '2.3.5'

gem 'mysql',            '2.8.1'

group :plugins do
  gem 'behavior',       '0.2.0'
end
```

Save and re run the rake task, if you are like me and had two or three
of these lurking, you will have to work out which ones to put into the
:plugins group yourself, the type of plugin is usually pretty obvious.

blogLater

Mikel

