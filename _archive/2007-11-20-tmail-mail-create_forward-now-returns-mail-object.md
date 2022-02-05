---
title: "TMail::Mail#create_forward now returns mail object"
author: Mikel Lindsaar
date: 2007-11-20
layout: post
redirect_from:
  - /2007/11/20/tmail-mail-create_forward-now-returns-mail-object
---
TMail::Mail instances had an instance method called create_forward
hidden away in net.rb. We move it up into the big time with [ticket
15445](http://rubyforge.org/tracker/index.php?func=detail&aid=15445&group_id=4512&atid=17370)

This method was hidden away in net.rb inside the lib/tmail directory.

What this method was meant to do is allow you to make a forwarded email
that you can then populate with a body and send onto someone.

It was inside net.rb, so you used to have to require it with "require
'tmail/net'" but now it has been moved into interface.rb with the other
main TMail instance methods.

So, how do you use it?

Well, like this.

Say you get an email in a file that you want to load in and reply to
called my_email. Then you just go ahead and do the following:

``` ruby
mail = TMail::Mail.load("my_email")
forwarded_email = mail.create_forward
forwarded_email.to = "you <you@you.com>"
forwarded_email.from = "me <me@me.com>"
forwarded_email.subject = "Here is that forwarded email I was talking about"
body =<<HEREDOC
Hey you,

Here is that email I was talking about!

Mikel
HEREDOC
forwarded_email.body = body
```

In fact, the forwarded email is a totally new, real, live spanking
TMail::Mail instance, so you can add attachments, add reply-to's or
whatever else you want to do to the object before you send it off!

Pretty cool hey?

blogLater

Mikel

