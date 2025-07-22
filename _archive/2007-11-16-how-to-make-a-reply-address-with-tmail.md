---
title: "How to make a reply address with TMail"
author: Mikel Lindsaar
date: 2007-11-16
layout: home
redirect_from:
  - /2007/11/16/how-to-make-a-reply-address-with-tmail
---


[TMail](http://tmail.rubyforge.org/) is quite an extensive mailing
library that is suffering from incredibly documentation pains.

The easy stuff is simple, like
`mail.to gives you the to address of the email, and `mail.to="something"
sets the to address to something.

But there are some other things that TMail can do to make your life
simple and easy and I am going to document them here on this blog.

Recently there was a bug request
[15445](http://rubyforge.org/tracker/index.php?func=detail&aid=15445&group_id=4512&atid=17370)
on the create_forward function.

I have fixed this bug and closed the ticket and merged the changes back
into trunk of TMail.

But what this means now is that you can do the following:

``` ruby
mail = TMail::Mail.load("/path/to/my_email_message")
forwarded_email = @mail.create_forward
forwarded_email.to = "New address <me@me.com>"
text = "Dear me\n\nHere is that email I was talking about!\n"
forwarded_email.body = text
```

And then you can just send the forwarded_email.

"create_forward" nicely takes the existing email, encodes it into 7-bit
ASCII, and the inserts it as an attachment to a new email which it
returns to you... Handy :)

"create_forward" is an existing method that has been moved into the main
interface.rb file of TMail which means that it will be available to any
mail object with a simple require 'tmail' in your ruby or rails code.

Hope you enjoy it!

blogLater

Mikel
