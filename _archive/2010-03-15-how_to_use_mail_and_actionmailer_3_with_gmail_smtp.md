---
title: "How to use Mail / ActionMailer 3 with GMail SMTP"
author: Mikel Lindsaar
date: 2010-03-15
layout: post
redirect_from:
  - /2010/3/15/how_to_use_mail_and_actionmailer_3_with_gmail_smtp
---
Getting Mail (and therefore ActionMailer 3) working with GMail SMTP is
crazy simple, if you know how.

The secret is actually in the Mail RDoc, but to save you looking, here
you are:

Mail allows you to send emails using SMTP. This is done by wrapping
Net::SMTP in\
an easy to use manner.

### Sending via SMTP server on Localhost

Sending locally (to a postfix or sendmail server running on localhost)
requires\
no special setup. Just do

``` ruby
Mail.deliver do
       to 'mikel@test.lindsaar.net'
     from 'ada@test.lindsaar.net'
  subject 'testing sendmail'
     body 'testing sendmail'
end

# Or:

mail = Mail.new do
       to 'mikel@test.lindsaar.net'
     from 'ada@test.lindsaar.net'
  subject 'testing sendmail'
     body 'testing sendmail'
end

mail.deliver
```

And your email will be fired off to your localhost SMTP server.

### Sending via GMail

To send out via GMail, you need to configure the `Mail::SMTP` class to
have the correct values, so to try this out, open up IRB and type the
following:

``` ruby
require 'mail'
options = { :address              => "smtp.gmail.com",
            :port                 => 587,
            :domain               => 'your.host.name',
            :user_name            => '<username>',
            :password             => '<password>',
            :authentication       => 'plain',
            :enable_starttls_auto => true  }

Mail.defaults do
  delivery_method :smtp, options
end
```

The last block calls `Mail.defaults` which allows us to set the global
delivery method for all mail objects that get created from now on. Power
user tip, you don't have to use the global method, you can define the
delivery_method directly on any individual `Mail::Message` object and
have different delivery agents per email, this is useful if you are
building an application that has multiple users with different servers
handling their email.

### Delivering the email

Once you have the settings right, sending the email is done the same way
as you would for a local host delivery default:

``` ruby
Mail.deliver do
       to 'mikel@test.lindsaar.net'
     from 'ada@test.lindsaar.net'
  subject 'testing sendmail'
     body 'testing sendmail'
end
```

Or by calling deliver on a Mail message

``` ruby
mail = Mail.new do
       to 'mikel@test.lindsaar.net'
     from 'ada@test.lindsaar.net'
  subject 'testing sendmail'
     body 'testing sendmail'
end

mail.deliver
```

### Combining this with ActionMailer 3

So as ActionMailer 3 uses Mail as it's email transport agent, all you
have to do is pass the same options Hash into ActionMailer:

``` ruby
ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => 'your.host.name',
  :user_name            => '<username>',
  :password             => '<password>',
  :authentication       => 'plain',
  :enable_starttls_auto => true  }
}
```

Hope that helps!

blogLater

Mikel

