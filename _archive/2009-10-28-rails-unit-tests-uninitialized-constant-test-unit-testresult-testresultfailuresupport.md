---
title: "Rails Unit Tests: uninitialized constant error"
author: Mikel Lindsaar
date: 2009-10-28
layout: post
redirect_from:
  - /2009/10/28/rails-unit-tests-uninitialized-constant-test-unit-testresult-testresultfailuresupport
---
Rails doesn't play well with test-unit 2.x... if you try you get
something like: Test::Unit::TestResult::TestResultFailureSupport on from
/Library/Ruby/Gems/1.8/gems/test-unit-2.0.5/lib/test/unit/testresult.rb:28

If you are getting something like this:

``` sh
mikel@baci.local ~/rails_programs/rails/actionmailer
 $ rake test
(in /Users/mikel/rails_programs/rails/actionmailer)
/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby -I"lib:test" "/Library/Ruby/Gems/1.8/gems/rake-0.8.7/lib/rake/rake_test_loader.rb" "test/adv_attr_test.rb" "test/asset_host_test.rb" "test/delivery_method_test.rb" "test/mail_helper_test.rb" "test/mail_layout_test.rb" "test/mail_render_test.rb" "test/mail_service_test.rb" "test/quoting_test.rb" "test/test_helper_test.rb" "test/tmail_test.rb" "test/url_test.rb" 
DEPRECATION WARNING: ActiveSupport::DeprecatedCallbacks has been deprecated in favor of ActiveSupport::Callbacks. (called from included at /Users/mikel/rails_programs/rails/actionmailer/lib/../../actionpack/lib/../../activesupport/lib/active_support/testing/setup_and_teardown.rb:7)
/Users/mikel/rails_programs/rails/actionmailer/lib/../../actionpack/lib/../../activesupport/lib/active_support/dependencies.rb:116:in `const_missing': uninitialized constant Test::Unit::TestResult::TestResultFailureSupport (NameError)
    from /Library/Ruby/Gems/1.8/gems/test-unit-2.0.5/lib/test/unit/testresult.rb:28
    from /Library/Ruby/Site/1.8/rubygems/custom_require.rb:31:in `gem_original_require'
    from /Library/Ruby/Site/1.8/rubygems/custom_require.rb:31:in `require'
    from /Users/mikel/rails_programs/rails/actionmailer/lib/../../actionpack/lib/../../activesupport/lib/active_support/dependencies.rb:167:in `require'
    from /Users/mikel/rails_programs/rails/actionmailer/lib/../../actionpack/lib/../../activesupport/lib/active_support/dependencies.rb:537:in `new_constants_in'
    from /Users/mikel/rails_programs/rails/actionmailer/lib/../../actionpack/lib/../../activesupport/lib/active_support/dependencies.rb:167:in `require'
    from /Library/Ruby/Gems/1.8/gems/test-unit-2.0.5/lib/test/unit/ui/testrunnermediator.rb:9
```

Then you need to downgrade from test-unit 2.x to test-unit 1.2.3 or so.

``` sh
# gem uninstall test-unit
# gem install test-unit -v 1.2.3
```

Enjoy

