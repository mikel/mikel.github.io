---
title: "Saving TMail into an ActiveRecord model"
author: Mikel Lindsaar
date: 2007-11-22
layout: post
redirect_from:
  - /2007/11/22/saving-tmail-into-an-activerecord-model
---
ActiveRecord works well when we are saving strings and integers, but
what if you want to save a real, live, honest-to-God Ruby OBJECT like a
TMail::Mail instance?? Well.. serialize to the rescue!

Today I had an interesting need.

I am making an Email transfer system, which, in part, needs to be able
to save an Email for later inspection, retrieval or queries.

While this system is not a Ruby on Rails app, I decided to use
ActiveRecord anyway as it is an awesome database interface, plugged in
with a local copy of SQLite3, I had my entire datastore handy.

The system that this is replacing stores the objects on disk using Ruby'
marshalling methods, but ActiveRecord has a much cleaner implementation
for use when you are saving to and from a database, it is invoked using
the serialize method.

So, in my case I have a class called Email, which, when you create it
with a raw source of an email text, initializes itself and parses that
email text into a TMail::Mail object which it stores as an ActiveRecord
attribute.

So, I wrote a spec like this:

``` ruby
email_text = IO.read("#{File.dirname(__FILE__)}/../fixtures/raw_email")

it "should create a tmail object as a TMail::Mail object" do
  mail = {:email => email_text}
  mail.email.class.should == TMail::Mail
end
```

To make this pass:

``` ruby
require 'tmail'
class Email < ActiveRecord::Base
  def initialize(email)
    super
    self.email = TMail::Mail.parse(email[:email])
  end
end
```

OK, that passes, pretty straight forward.

But now, what if I call:

``` ruby
mail.save
mail = Email.find(:first)
mail.email.class #=> String 
```

So that doesn't work, what I want is to be able to save that object to a
database, and then, when I recall it from the database, have the same
model I started with.

OK, so first, we'll write a spec for that:

``` ruby
it "should save itself to the and serialize it's mail component" do
  mail = create_email
  mail.save!
  mail = Mailer::Email.find(:first)
  mail.email.class.should == TMail::Mail
end
```

That fails, now we use the serialize method of ActiveRecord.

To do this, you need to make the "mail" record of the Emails table a
TEXT field. This is important.

Then we go into the class definition and add the following:

``` ruby
require 'tmail'
class Email < ActiveRecord::Base

  serialize :email

  def initialize(email)
    super
    self.email = TMail::Mail.parse(email[:email])
  end
end
```

With that serialize :email, the ActiveRecord class will convert the
TMail object into a text string through YAML and save it to the database
as a text string. When it recalls it from the database, it will read
this string via YAML and reinstate the object in all it's ruby glory.

Pretty handy!

blogLater

Mikel

