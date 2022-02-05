---
title: "Tip #4 - Validating an Email Address with Ruby on Rails"
author: Mikel Lindsaar
date: 2008-04-14
layout: post
redirect_from:
  - /2008/4/14/tip-4-detecting-a-valid-email-address
---
Did you know that Rails has inbuilt a strong email handling library
called (ahem) [TMail?](http://tmail.rubyforge.org/) I just so happen to
maintain this now ([Minero Aoki](http://i.loveruby.net/) wrote it), but
it gives you a great way to validate email addresses...

### Update

Rails 3.0 uses Mail now instead of TMail, here is another simple way to
[validate an
email](https://lindsaar.net/2010/1/31/validates_rails_3_awesome_is_true).

### Original Post:

If you have ever tried to handle the validation of email addresses in
your Rails app, you have probably ended up trying to use something like
this to validate the address:

``` ruby
validates_format_of :email,
   :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
```

Now, this works... in *most* cases, but there are a few specifics that
won't.

So some of you out there decide that you want a REAL email validation
process and so you go for this regular expression instead:

``` ruby
EmailAddress = begin
  qtext = '[^\\x0d\\x22\\x5c\\x80-\\xff]'
  dtext = '[^\\x0d\\x5b-\\x5d\\x80-\\xff]'
  atom = '[^\\x00-\\x20\\x22\\x28\\x29\\x2c\\x2e\\x3a-' +
    '\\x3c\\x3e\\x40\\x5b-\\x5d\\x7f-\\xff]+'
  quoted_pair = '\\x5c[\\x00-\\x7f]'
  domain_literal = "\\x5b(?:#{dtext}|#{quoted_pair})*\\x5d"
  quoted_string = "\\x22(?:#{qtext}|#{quoted_pair})*\\x22"
  domain_ref = atom
  sub_domain = "(?:#{domain_ref}|#{domain_literal})"
  word = "(?:#{atom}|#{quoted_string})"
  domain = "#{sub_domain}(?:\\x2e#{sub_domain})*"
  local_part = "#{word}(?:\\x2e#{word})*"
  addr_spec = "#{local_part}\\x40#{domain}"
  pattern = /\A#{addr_spec}\z/
end
```

And then your validates_format_of becomes:

``` ruby
validates_format_of :email,
   :with => EmailAddress
```

Which is neat, but you have to stuff that Regex away somewhere. When I
used this, (by the way) I would make a file in /lib called 'rfc822.rb'
and then put this in it:

``` ruby
#
# RFC822 Email Address Regex
# --------------------------
#
# Originally written by Cal Henderson
# c.f. http://iamcal.com/publish/articles/php/parsing_email/
#
# Translated to Ruby by Tim Fletcher, with changes suggested by Dan Kubb.
#
# Licensed under a Creative Commons Attribution-ShareAlike 2.5 License
# http://creativecommons.org/licenses/by-sa/2.5/
#
module RFC822
  EmailAddress = begin
    qtext = '[^\\x0d\\x22\\x5c\\x80-\\xff]'
    dtext = '[^\\x0d\\x5b-\\x5d\\x80-\\xff]'
    atom = '[^\\x00-\\x20\\x22\\x28\\x29\\x2c\\x2e\\x3a-' +
      '\\x3c\\x3e\\x40\\x5b-\\x5d\\x7f-\\xff]+'
    quoted_pair = '\\x5c[\\x00-\\x7f]'
    domain_literal = "\\x5b(?:#{dtext}|#{quoted_pair})*\\x5d"
    quoted_string = "\\x22(?:#{qtext}|#{quoted_pair})*\\x22"
    domain_ref = atom
    sub_domain = "(?:#{domain_ref}|#{domain_literal})"
    word = "(?:#{atom}|#{quoted_string})"
    domain = "#{sub_domain}(?:\\x2e#{sub_domain})*"
    local_part = "#{word}(?:\\x2e#{word})*"
    addr_spec = "#{local_part}\\x40#{domain}"
    pattern = /\A#{addr_spec}\z/
  end
end
```

And then in my model:

``` ruby
include RFC822
validates_format_of :email,
   :with => EmailAddress
```

Which is getting better. But the problem with that now is that you need
to maintain that email address regular expression... which is quite...
umm... "complex" I think is a good word :)

#### Enter TMail!

TMail has an "Address" class. It will throw an invalid address exception
if given an address it can't handle (and it has about 2,000 test cases
of email addresses it *can* handle, so you are pretty safe.)

Plus, as the maintainer, whenever I find a valid email that TMail can
not handle, I fix it, and then you benefit at the next gem install
tmail... so it all turns out good :)

To use it, dump this in your user model somewhere (assuming your user
model has the attribute 'email_address')

``` ruby
def valid_email?
  TMail::Address.parse(email)
rescue
  errors.add_to_base("Must be a valid email")
end
```

Then your validates_format_of becomes:

``` ruby
validate :valid_email?
```

Which is even nicer.. as in... less code == nicer :)

Next tip =\> How to validate the address *fully* before accepting it...

blogLater

Mikel

