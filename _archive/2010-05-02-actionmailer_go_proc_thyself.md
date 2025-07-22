---
title: "Action Mailer, go Proc thyself"
author: Mikel Lindsaar
date: 2010-05-02
layout: home
redirect_from:
  - /2010/5/2/actionmailer_go_proc_thyself
  - /2010/5/3/actionmailer_go_proc_thyself
---
On my recent [Rails
Dispatch](http://www.railsdispatch.com/posts/actionmailer) screen cast,
I had a seemingly innocent example of a default header, using `Time.now`
to insert a time stamp.

It was an innocent thing, and truthfully, I had it there more as an
example than something I would do in production.

Nevertheless, good Ruby aficionados will recognise the mistake from a
thousand miles away, the default hash inside of Action Mailer gets read,
parsed and evaluated at compile time, not on a per message basis...
which makes it basically useless as a Time stamp.

Rick DeNatale pointed this out in a question to me at
[RailsDispatch](http://www.railsdispatch.com/community/questions/), he
also asked if Action Mailer supports Proc objects inside of the default
hash.

Sadly, the answer was no.

But then a [few hours
later](http://github.com/rails/rails/commit/ceaa100e59c7953ce5c0e978ddd6d5bc046c9fd9)
it was yes!

So now you can pass in `Proc` objects to your Action Mailer class
default method, like so:

``` ruby
class Notifier < ActionMailer::Base
  default :to => 'system@test.lindsaar.net',
          :subject => Proc.new { give_a_greeting }

  def welcome
    mail
  end

  private

  def give_a_greeting
    "This is a greeting at #{Time.now}"
  end
end
```

Which would then call the `give_a_greeting` method on your Mailer
instance to create a value to assign to the subject field.

Enjoy!

blogLater

Mikel
