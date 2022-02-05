---
title: "Mail and Bounced Emails"
author: Mikel Lindsaar
date: 2009-09-18
layout: post
redirect_from:
  - /2009/9/18/mail-and-bounced-emails
---
You might have to deal with bounced emails in your application. The new
mail library makes this a no brainer...

I like code more than words... so:

``` ruby
require 'mail'

@mail = Mail.read('/path/to/bounce_message.eml')

# You can also do Mail.new('String of email message')

@mail.bounced?
#=> true
@mail.final_recipient
#=> rfc822;mikel@dont.exist.com
@mail.action
#=> failed
@mail.error_status
#=> 5.5.0
@mail.diagnostic_code  
#=> smtp;550 Requested action not taken: mailbox unavailable 
@mail.retryable?
#=> false
```

You can get mail from my [GitHub
repository](http://www.github.com/mikel/mail/)

Once we finish a few more points in the library, I'll release a gem.

Mikel

