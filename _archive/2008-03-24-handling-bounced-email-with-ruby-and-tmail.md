---
title: "Handling Bounced Email with Ruby and TMail"
author: Mikel Lindsaar
date: 2008-03-24
layout: home
redirect_from:
  - /2008/3/24/handling-bounced-email-with-ruby-and-tmail
---
If you are using a Ruby on Rails app, or Nitro, or just a plain Ruby
application that handles email, you will need to handle at some point,
bounced messages. This a simple way to get to the guts of the email and
find out what the error codes are...

Here we go:

We need to get an email to handle, so something like:

``` ruby
mail = TMail::Mail.parse(message)
```

Then, we need to check if this is a bounced email or not, so:

``` ruby
mail.content_type == 'multipart/report'
```

This will return true or false, if it is true, we need to do more
handling to find out the error codes etc.

So, first, find the part of the email that has the
message/delivery-status section like this:

``` ruby
delivery_status_part = mail.parts.detect do |part|
  part.content_type == 'message/delivery-status'
end
```

Now we have the delivery status part, we need to pull out the keys and
values, a delivery status body will usually look something like this:

``` shell
Reporting-MTA: dns; mail9.mail.com.au
Received-From-MTA: DNS; 60-1-1-1.static.mail.com.au
Arrival-Date: Wed, 2 Jan 2008 20:38:15 +1100

Final-Recipient: RFC822; your_address@address.com
Action: failed
Status: 5.0.0
Remote-MTA: DNS; mx1.mail.yahoo.com
Diagnostic-Code: SMTP; 554 delivery error: dd This user doesn't have a
 address.com account (your_address@address.com) [0] -
 mta813.mail.yahoo.com
Last-Attempt-Date: Wed, 2 Jan 2008 20:38:18 +1100
```

Notice the nice and handy key value pairs separated by ':' ? This makes
pulling the main data we need easy by doing:

``` ruby
lines = delivery_status_part.body.split("\n")
info = lines.inject({}) do |hash, line|
  key, value = line.split(/:/)
  key.downcase! rescue nil
  hash[key] = value.strip rescue nil
  hash
end
```

Now we have a hash that looks like:

``` ruby
{"status"=>"5.0.0",
 "diagnostic-code"=>"SMTP; 554 delivery error",
 "remote-mta"=>"DNS; mx1.bt.mail.yahoo.com",
 "arrival-date"=>"Wed, 2 Jan 2008 20",
 "action"=>"failed",
 nil=>nil,
 "reporting-mta"=>"dns; mail9.tpgi.com.au",
 "final-recipient"=>"RFC822; Angelina@btinternet.com",
 "received-from-mta"=>"DNS; 60-241-138-146.static.tpgi.com.au",
 "last-attempt-date"=>"Wed, 2 Jan 2008 20"}
```

The nil there in the middle is from the Diagnostic-Code line that wraps.
I am not handling unfolding the line in this as to get the details we
need, we don't need to.

So, now we have a key/value hash, we can pull the data we need very
easily:

``` ruby
info['status']          #=> "5.0.0"
info['final-recipient'] #=> "RFC822; Angelina@btinternet.com"
info['action']          #=> "failed"
info['diagnostic-code'] #=> "SMTP; 554 delivery error"
```

Now you can do whatever you want to the message.

blogLater

Mikel
