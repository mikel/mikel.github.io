---
title: "Tip #6 - Validating the Domain of an Email Address with Ruby on Rails"
author: Mikel Lindsaar
date: 2008-04-15
layout: post
redirect_from:
  - /2008/4/15/tip-6-validating-the-domain-of-an-email-address-with-ruby-on-rails
  - /2008/4/13/tip-6-validating-the-domain-of-an-email-address-with-ruby-on-rails
---
So, in the last two tips, I have shown how to check the format of the
email and save the actual address only in the database. But how to check
that the email domain name is valid? Easy!

When you are getting an email address from a user, sometimes it might
not matter that it is not a real address (like on this blog, I don't
check).

But if you are creating an account, yeah, it matters, you want to know
that the address is for the right person.

Now, the only way you can really do this is by sending them a
confirmation email that they have to reply to. But, when the user is
filling out the form, we should do everything we can, then and there to
make sure that the address is correct, especially since we don't want
them sitting, waiting at their inbox for the email that will never come!

Luckily again, using TMail and a bit of built in ruby goodness, we can
do something about it.

What we need to do in a nutshell, is take the email address, split off
the domain, look up the domain, find any mail exchanger records for that
domain and then if all of that passes, accept the email address as
probably valid.

If any of those steps fail though, we know that the domain name is
either an incorrect one, or misspelt somehow.

Anyway, enough talk, lets see the code.

First we need to set up the validation, so I am going to assume you are
using the email validation from [Tip
#4](https://lindsaar.net/2008/4/14/tip-4-detecting-a-valid-email-address)
and so I am just going to add to it:

``` ruby
class User < ActiveRecord::Base

  validate :valid_email?

  def valid_email?
    begin
      domain_name = TMail::Address.parse(email).domain
      domain_valid?(domain_name)
    rescue
      errors.add(:email, "has an invalid format.")
    end
  end

end
```

Now, what I have added is the "addr =
TMail::Address.parse(email).domain", what does this do? Well, lets ask
the console:

``` ruby
TMail::Address.parse('Mikel A. <spam@lindsaar.net>').domain
#=> "lindsaar.net"
TMail::Address.parse('spam@ruby-lang.org').domain
#=> "ruby-lang.org"
```

As you can see, it parses the email, then finds the domain name and
gives it back to you as a string, very handy!

So after I did that, I make a call to "domain_valid?(domain_name)", now,
unfortunately, this isn't built into Ruby or Rails, but it is pretty
simple to set up. To do it, we need the resolv library that ships with
Ruby, so, in your User class still, you can add the following method:

``` ruby
class User < ActiveRecord::Base

  require 'resolv'

  def domain_valid?(domain)
    Resolv::DNS.open do |dns|
      @mx = dns.getresources(domain.to_s, Resolv::DNS::Resource::IN::MX)
    end
    if @mx.empty?
      errors_add(:email, 'domain name can not be found.')
    end
  end

end
```

Now, this method is fairly neat.

What it does is load the resolve library, then it opens up the DNS
system, and gets all the MX records for the domain name you give it. If
there are MX records (which means there is a way for SMTP servers to
route email to the domain name recipient) then the instance variable
\@mx will be an array containing each MX record object. So all we have
to do is check to see if that is empty or not. If it is, we know that
there are no MX records and so we add an error to the object on the
email attribute that tells the user that the domain name is invalid.

So, there you go. Your user fills out the form, and you do a quick check
on the domain name to see if the domain has an MX record as WELL as
checking that the address itself is valid.

Now the only way a user can enter a wrong address and you accept it, is
if they enter a false address, but this, you will catch with your
verification email, and besides, this type of user will not be waiting
for their verification email anyway, so who cares?

blogLater

Mikel

