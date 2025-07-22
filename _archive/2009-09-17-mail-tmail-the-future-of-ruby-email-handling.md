---
title: "Mail, TMail, The Future of Ruby Email Handling"
author: Mikel Lindsaar
date: 2009-09-17
layout: home
redirect_from:
  - /2009/9/17/mail-tmail-the-future-of-ruby-email-handling
---
You may know I maintain the TMail library. Well, recently I've been
working on the next version.

TMail was getting hard to maintain and monkey patch. It's implementation
does not take into account many little things that create a problem when
trying to get Ruby 1.9 compatibility working.

Anyway, I started working on Mail... code speaks louder than words... so
Mail can do the following right now:

``` ruby
Mail.defaults do
  smtp '127.0.0.1'
end

Mail.deliver do
  to 'nicolas@test.lindsaar.net.au'
  from 'Mikel Lindsaar <mikel@test.lindsaar.net.au>'
  subject 'First multipart email sent with Mail'
  text_part do
    body 'Here is the attachment you wanted'
  end
  html_part do
    content_type 'text/html; charset=UTF-8'
    body '<h1>Funky Title</h1><p>Here it is</p>'
  end
  add_file :filename => '/path/to/myfile.pdf'
end
```

And you just sent a multipart text and html email with an attachment!

Mail is my attempt to just HANDLE the problem of Ruby Email handling.

I developed it from the ground up with complete spec coverage... I am
not *quite* at 100%... but very close. It is also a completely object
oriented design and pure ruby too!

Mail tries it's darn hardest not to crash. In fact it already checks
every email in the TMail test suite and doesn't crash once on parsing
any of the emails in there.

In any case, I now have pretty much all the basic email and mime and
attachment handlings working. Next up is handling multiple character
sets in the header and body.

You are welcome to check it out from my [GitHub
account](http://github.com/mikel/mail)

It's version 0.1 right now... but expect to see the multi character set
support soon.

Forks and patches welcome!

Mikel
