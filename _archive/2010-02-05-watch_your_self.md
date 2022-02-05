---
title: "Watch your self "
author: Mikel Lindsaar
date: 2010-02-05
layout: post
redirect_from:
  - /2010/2/5/watch_your_self
---
Blocks and closures are probably the most powerful, and least understood
part of the Ruby programming language, combined `instance_eval`, it can
create some unintuitive bugs.

### Background

In my Mail library for Ruby, I have made use of `instance_eval` to
provide a domain specific language for email, this allows me to offer
the following as valid Ruby code:

``` ruby
m = Mail.new do
       to 'mikel@test.lindsaar.net'
     from 'you@test.lindsaar.net'
  subject 'This is a valid email'
     body "When this block closes it will " +
          "return an email message."
end
```

This bit of code is calling the #new method on the Mail module, which
accepts a block. This which creates a new `Mail::Message`, passing the
block of ruby code which in turn calls `instance_eval` on itself,
passing the Ruby code that is inside the block of code that we wrote
between the `do` and `end` keywords.

The newly created `Mail::Message` now runs that block on itself, calling
the `to()`, `from()`, `subject()` and `body()` methods in turn, passing
the strings we gave it.

Once done, the Mail module then calls deliver on the `Mail::Message` and
the email is sent on its way.

The code that makes the above happen is inside the Mail library:

``` ruby
module Mail

  class Message
    def initialize
      # ... initialization
      if block_given?
        instance_eval(&block)
      end
    end
  end

  def Mail.new(*args, &block)
    Mail::Message.new(args, &block)
  end

end
```

### Gotcha

All of the above is pretty straight forward and it works pretty much as
you would expect, but there is one use case that will trip you up.

Suppose you don't want to pass in strings to your Mail object? Suppose
you want to pass in **instance variables** instead? Something like this:

``` ruby
@text = "When this block closes it will " +
        "return an email message."
@to   = 'mikel@test.lindsaar.net'
@subject = "This is a valid email"

Mail.new do
       to @to
     from 'you@test.lindsaar.net'
  subject @subject
     body @text_body
end
```

This ruby code will run successfully, but it will not return what you
think. This is because the instance variables you pass into the block
are evaluated within the scope of the `Mail::Message` and inside the
`Mail::Message`, `@text`, `@to` and `@subject` all evaluate to `nil`.

This is where you need to watch your self. Inside of the
`Mail.new do.. end` block, self effectively becomes the `Mail::Message`,
and the mail message has not defined the instance variables you are
passing in.

### Solutions

To get around this, you can do a number of things.

First, you can use methods instead of instance variables:

``` ruby
def body_text
  "When this block closes it will " +
  "return an email message."
end

def to_address
  'mikel@test.lindsaar.net'
end

def default_subject
  "This is a valid email"
end

Mail.new do
       to to_address
     from 'you@test.lindsaar.net'
  subject default_subject
     body body_text
end
```

This is obviously a lot more code, but in practice you usually have the
to, subject and body text already being generated by methods inside your
code, so it can work.

The other solution is a lot more simple, don't use a block:

``` ruby
@text = "When this block closes it will " +
        "return an email message."
@to   = 'mikel@test.lindsaar.net'
@subject = "This is a valid email"

m = Mail.new
m.to @to
m.from 'you@test.lindsaar.net'
m.subject @subject
m.body @text
```

Which is arguably less pretty, but you are not going to get caught out.

blogLater

Mikel
