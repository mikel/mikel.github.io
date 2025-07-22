---
title: "undefined local variable or method `version_requirements'"
author: Mikel Lindsaar
date: 2011-06-29
layout: home
redirect_from:
  - /2011/6/29/undefined-local-variable-or-method-version_requirements
  - /2011/6/30/undefined-local-variable-or-method-version_requirements
---
If you have a Rails 2.x app and hitting this, there is a simple fix
while you wait to upgrade to Rails 3.

Edit your environment.rb file and inbetween the `require 'boot'` line
and the `Rails::Initializer` line, insert the following `Gem::VERSION`
if statement:

``` ruby
# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

if Gem::VERSION >= "1.3.6"
  module Rails
    class GemDependency
      def requirement
        (super == Gem::Requirement.default) ? nil : super
      end
    end
  end
end

Rails::Initializer.run do |config|
# ....
```

It's a hack, it might break with later and later releases of RubyGems.
But it allowed me to get a 2.3.x Rails app running on a fairly current
rubygems.
