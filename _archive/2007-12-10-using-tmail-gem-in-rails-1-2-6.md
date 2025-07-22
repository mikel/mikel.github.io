---
title: "Using TMail Gem in Rails 1.2.6"
author: Mikel Lindsaar
date: 2007-12-10
layout: home
redirect_from:
  - /2007/12/10/using-tmail-gem-in-rails-1-2-6
---
Ruby on Rails 2.0 includes the ability to load a gem version of TMail
instead of the bundled version inside of ActionMailer. However, if you
are running on Rails 1.2.6, this doesn't help you much. Here is how you
take advantage of the latest fixes to the TMail library and stay in the
1.2.x branch of Rails

To do this you need to be willing to hack into your copy of rails
though. The change isn't too hard, but it is significant.

First, it's a good idea to do this on a frozen version of Rails inside
your app. So from your app's dir, do the following:

``` shell
baci:~/myapp/ mikel$ rake rails:freeze:edge TAG=rel_1-2-6
```

This gets you a full copy of Ruby on Rails version 1.2.6 inside of the
vendor/rails directory.

The next thing we need to do is to run all the tests inside of
ActionMailer. This is important so that we know we have been successful
in patching ActionMailer.

So, cd into rails/vendor/actionmailer and run rake test. When I do this
on version 1-2-6 I get the following errors:

``` shell
baci:~/myapp/ mikel$ cd vendor/rails/actionmailer
baci:~/myapp/rails/vendor/actionmailer/ mikel$ rake test
(in /Users/mikel/blog/lindsaar/vendor/rails/actionmailer)
/usr/local/bin/ruby -Ilib:test
"/usr/local/lib/ruby/gems/1.8/gems/rake-0.7.3/lib/rake/rake_test_ldr.rb"
"test/mail_helper_test.rb" "test/mail_render_test.rb"
"test/mail_service_test.rb" "test/quoting_test.rb"
"test/tmail_test.rb" "test/url_test.rb"
Loaded suite
/usr/local/lib/ruby/gems/1.8/gems/rake-0.7.3/lib/rake/rake_test_loader
Started
.......F...F.................................F..............F....
Finished in 0.260182 seconds.

  1) Failure:
test_decode_attachment_without_charset(ActionMailerTest)
[./test/mail_service_test.rb:584]:
<1026> expected but was
<1>.

  2) Failure:
test_decode_message_with_unquoted_atchar_in_header(ActionMailerTest)
[./test/mail_service_test.rb:755]:
<nil> expected to not be nil.

  3) Failure:
test_unquote_base64_body(ActionMailerTest)
[./test/mail_service_test.rb:503]:
<"The body"> expected but was
<"T">.

  4) Failure:
test_email_with_partially_quoted_subject(QuotingTest)
[./test/quoting_test.rb:31]:
<"Re: Test: \"\346\274\242\345\255\227\" mid
 \"\346\274\242\345\255\227\" tail">
expected but was
<"Re: Test: \" mid \" tail">.

65 tests, 174 assertions, 4 failures, 0 errors
baci:~/blog/lindsaar/vendor/rails/actionmailer mikel$
```

Failing test! YIKES!

OK, well, that is why we are putting in a new version of TMAIL!

So, from the vendor/rails directory open up the
actionmailer/lib/action_mailer.rb file and insert the following lines
after the first begin end block:

``` ruby
begin
  require 'rubygems'
  gem 'tmail'
  require 'tmail'
end
```

What this does is from inside a begin end block, will try and use the
installed gem version of TMail instead of the bundled version, if this
fails with an exception, it will then load the TMail that is in the
vendor directory inside of ActionMailer with the second require 'tmail'
statement around line 46.

If you are not sure where to put this, look at the bottom of this post
for the full action_mailer.rb file.

However, if it does succeed in loading TMail from the gem, the line 46
require 'tmail' will return false as tmail is already loaded.

Once you have done this, save the file and run the tests again.

This time you should see something like this:

``` shell
baci:~/blog/lindsaar/vendor/rails/actionmailer mikel$ rake test
(in /Users/mikel/blog/lindsaar/vendor/rails/actionmailer)
/usr/local/bin/ruby -Ilib:test
"/usr/local/lib/ruby/gems/1.8/gems/rake-0.7.3/lib/rake/rake_test_ldr.rb"
"test/mail_helper_test.rb" "test/mail_render_test.rb"
"test/mail_service_test.rb" "test/quoting_test.rb" "test/tmail_test.rb"
"test/url_test.rb"
Loaded suite
/usr/local/lib/ruby/gems/1.8/gems/rake-0.7.3/lib/rake/rake_test_loader
Started
...........F.....................................................
Finished in 0.3203 seconds.

  1) Failure:
test_decode_message_with_unquoted_atchar_in_header(ActionMailerTest)
[./test/mail_service_test.rb:755]:
<nil> expected to not be nil.

65 tests, 175 assertions, 1 failures, 0 errors
baci:~/blog/lindsaar/vendor/rails/actionmailer mikel$
```

OK, we got that down to one failing test, but that test doesn't count as
it was recently removed from the ActionMailer test suite in this [Rails
Dev ticket](http://dev.rubyonrails.org/ticket/10317#comment:6). You can
go into the test file in test/mail_service_test.rb and go to line 755
and comment out the whole test if you feel like it, but it doesn't
really matter.

So now you have Rails 1.2.6 running on the latest and greatest TMail.

Updating TMail in the future will now be as easy as "gem install tmail".

For reference the whole action_mailer.rb file will look like this:

``` ruby
#--
# Copyright (c) 2004-2006 David Heinemeier Hansson
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++

unless defined?(ActionController)
  begin
    $:.unshift "#{File.dirname(__FILE__)}/../../actionpack/lib"
    require 'action_controller'
  rescue LoadError
    require 'rubygems'
    gem 'actionpack', '>= 1.12.5'
  end
end

begin
  require 'rubygems'
  gem 'tmail'
  require 'tmail'
end

$:.unshift(File.dirname(__FILE__) + "/action_mailer/vendor/")

require 'action_mailer/base'
require 'action_mailer/helpers'
require 'action_mailer/mail_helper'
require 'action_mailer/quoting'
require 'tmail'
require 'net/smtp'

ActionMailer::Base.class_eval do
  include ActionMailer::Quoting
  include ActionMailer::Helpers

  helper MailHelper
end

silence_warnings { TMail::Encoder.const_set("MAX_LINE_LEN", 200) }
```

blogLater

Mikel
