---
title: "Tip #5 - Cleaning Up an Email Address with Ruby on Rails"
author: Mikel Lindsaar
date: 2008-04-14
layout: post
redirect_from:
  - /2008/4/14/tip-5-cleaning-up-an-verifying-an-email-address-with-ruby-on-rails
  - /2008/4/13/tip-5-cleaning-up-an-verifying-an-email-address-with-ruby-on-rails
---
So you have an email address field on a form in Rails, but how are you
going to make sure that all those users enter a sane and well formatted
email address? Here is a simple fix to that problem.

If you read the [previous
tip](https://lindsaar.net/2008/4/14/tip-4-detecting-a-valid-email-address)
then you would have setup some basic validation of the format of your
email address.

One thing I didn't tell you here is that it will also clean up any
address you give it.

To show you what I mean, lets try some basics in the console:

``` ruby
TMail::Address.parse('spam@lindsaar.net')
#=> #<TMail::Address spam@lindsaar.net>
TMail::Address.parse('spam@lindsaar.net').to_s
#=> "spam@lindsaar.net"
```

OK, no surprises there, we give tmail 'spam@lindsaar.net' and it returns
what we gave it.

But the magic comes when we enter some slightly wrong addresses. What
happens if the user accidently adds some spaces:

``` ruby
TMail::Address.parse('spam @ lindsaar . net').to_s
#=> "spam@lindsaar.net"
```

No problem, TMail sees that it is a basic mistake (though a bit
contrived) and handles it.

What else can it handle? Well, lets see:

``` ruby
TMail::Address.parse('"mikel" <spam@lindsaar.net>').to_s
#=> "mikel <spam@lindsaar.net>"
TMail::Address.parse('<spam@lindsaar.net>').to_s
#=> "spam@lindsaar.net"
TMail::Address.parse('Mikel A. <spam@lindsaar.net>').to_s
#=> "\"Mikel A.\" <spam@lindsaar.net>"
```

OK, the basics are covered.

But, what is nice is that you can choose just to save the email address
itself in your database, without the phrase at the front (that is the
bit that the owner of the address can put in quotes). You can do this
like so:

``` ruby
TMail::Address.parse('Mikel A. <spam@lindsaar.net>').spec
=> "spam@lindsaar.net"
```

So in your model, you can make a write attribute filter on the "email"
attribute of the class you are working on and do something like this:

``` ruby
class User < ActiveRecord::Base
  def email=(address)
    write_attribute(:email, TMail::Address.parse(address).spec)
  end
end
```

Which means the only thing saved in your model will be the actual email
address in a known and standard format.

Now, the only problem with this is that when you send an email to your
user, you want to put the phrase (the bit at the front with the name)
back into the email, that way it shows up as more of a personalized
email in their inbox. To do this is quite easy, just whack this in your
model (assuming you have a first_name and last_name attribute for your
user model):

``` ruby
class User < ActiveRecord::Base
  def email
    phrase = %("#{first_name} #{last_name}")
    address = read_attribute(:email)
    "#{phrase} <#{address}>"
  end
end
```

Now you will always get 'FirstName LastName \<email@domain.com&gt;' as
the address whenever you ask for the email of the person.

Nice hey?

Next tip, validating the email address by domain before saving.

blogLater

Mikel

