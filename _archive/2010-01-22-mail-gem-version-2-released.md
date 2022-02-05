---
title: "Mail gem version 2 released"
author: Mikel Lindsaar
date: 2010-01-22
layout: post
redirect_from:
  - /2010/1/22/mail-gem-version-2-released
  - /2010/1/23/mail-gem-version-2-released
---
The past month has seen a flurry in activity on the [Mail
gem](http://github.com/mikel/mail) but I just pushed 2.0.3 to GemCutter,
it is quite a release!

If you haven't heard of mail, you can get some background
[here](https://lindsaar.net/2009/9/17/mail-tmail-the-future-of-ruby-email-handling),
[here](https://lindsaar.net/2009/9/18/mail-and-bounced-emails),
[here](https://lindsaar.net/2009/10/28/new-mail-gem-released) and
[here](https://lindsaar.net/2009/11/1/mail-gets-some-compliments)

Mail is a very Ruby way to handle emails.

Version 2.0.3 is the first gem release I have in the last couple of
weeks, this is because I went through and (in good BDD style) refactored
major parts of the Mail gem so it handles better.

Some of the major things were:

### SMTP Delivery Agent revamped

I went through the SMTP delivery agent and cleaned it up, also adding
examples for how you use Mail with GMail and MobileMe so there is no
more guess work here.

### Delivery agents are now instance based

This means that each mail object that you instantiate can have its own
delivery method. Why is this important?

Well, say you are writing a web based email client for multiple users,
but each user has their own SMTP hosts, when you make a mail object for
that user, you could assign the delivery method for that user to that
mail object, then delivery is just calling .deliver! on the mail object,
and away it goes.

There is still default class wide settings for all the major delivery
agents (SMTP, Sendmail and File) however, you can now over ride these.

``` fixed
mail1 = Mail.new
mail1.delivery_method #=> #<Mail::SMTP:0x101381c18 @setting
mail2 = Mail.new
mail2.delivery_method :sendmail
mail2.delivery_method #=> #<Mail::Sendmail:0x101381c18 @setting
mail1.delivery_method #=> #<Mail::SMTP:0x101381c18 @setting
```

### Attachments are now just parts

Before, an Attachment had its own object type in Mail. This was nice and
all, but was just added cruft that got in there during the BDD cycle. I
ripped out the entire attachment class, and an attachment is now just a
plain old Mail::Part. This makes the code simpler, which is good for
everyone.

Mail also now has a very cool attachments API:

``` fixed
mail = Mail.new
mail.attachments #=> []
mail.attachments['filename.jpg'] = File.read('filename.jpg')
mail.attachments['file.pdf'] = {:content_type => 'application/x-pdf',
                                :content => File.read('file')
mail.attachments.length #=> 2
mail.attachments[0].filename #=> 'filename.jpg'
mail.attachments['filename.jpg'] #=> <# Mail::Part, filename = 'filename.jpg' ...>
```

Yes, that is an ArrayHashThingy™ class, and, it rocks :) It is actually
an AttachmentsList object that inherits from Array and implements a
custom \[\] class.

Thanks to [David](http://www.loudthinking.com/) and
[Yehuda](http://yehudakatz.com/) who were brainstorming on the new
ActionMailer 3.0 API with me, which I used for inspiration for this
implementation. (more on the ActionMailer 3.0 API that I am pair
programming with [José](http://blog.plataformatec.com.br/) later :)

### Mail returns default values for fields, that can be modified

Mail returns an array of address specs when you call
`<span class="fixed">`{=html}mail.to`</span>`{=html} and would
re-initialize that array with new values when you called
`<span class="fixed">`{=html}mail.to=`</span>`{=html}.

However, this array object was just a result of a method, it was not a
representation of the addresses within the address field, so then doing
`<span class="fixed">`{=html}mail.to \<\< value`</span>`{=html} would
seem to work (no error) but the address would get lost, for example:

``` fixed
# Old (unintuitive method)
mail = Mail.new("To: mikel@test.lindsaar.net")
mail.to #=> ['mikel@test.lindsaar.net']
mail.to << 'ada@test.lindsaar.net'
mail.to #=> ['mikel@test.lindsaar.net']
```

This now works on all Address fields that can take more than one
address, so

``` fixed
# New (intuitive) method
mail = Mail.new("To: mikel@test.lindsaar.net")
mail.to #=> ['mikel@test.lindsaar.net']
mail.to << 'ada@test.lindsaar.net'
mail.to #=> ['mikel@test.lindsaar.net', 'ada@test.lindsaar.net']
```

Thanks to [Sam](http://intertwingly.net/blog/) for suggesting this
feature.

### Access returned to the Address objects

When you call `<span class="fixed">`{=html}mail.to`</span>`{=html} you
get a list of address spec strings ('mikel@test.lindsaar.net' for
example), but it will not give you the display name, or formatted
address etc.

To handle this, you can now call mail\[:to\] to get the actual ToField
object, and then you can call #display_names, #formatted, and #addrs,
the last of which will give you the actual Address objects in an array
(the original behaviour of Mail), like so:

``` fixed
mail = Mail.new("To: Mikel Lindsaar <mikel@test.lindsaar.net>")
mail.to #=> ['mikel@test.lindsaar.net']
to = mail[:to]  #=> #<Mail::Field:0x10137c718...
to.addrs #=> [#<Mail::Address:2165620900 Address: |mikel@test.lindsaar.net| >]
to.addrs.each do |addr|
  puts "Formatted: #{addr.format}"
  puts "Display:   #{addr.display_name}"
  puts "Address:   #{addr.address}"
end
# Produces:
Formatted: Mikel Lindsaar <mikel@test.lindsaar.net>
Display:   Mikel Lindsaar
Address:   mikel@test.lindsaar.net
=> [#<Mail::Address:2165518560 Address: |Mikel Lindsaar <mikel@test.lindsaar.net>| >]
```

Thanks to [Karl](http://github.com/kbaum) for suggesting this would be
handy :)

### More methods added to address fields

You can also access an array of the formatted, display_names or
addresses directly from address fields:

``` fixed
mail = Mail.new("To: Mikel Lindsaar <mikel@test.lindsaar.net>")
mail[:to].addresses   
#=> ["mikel@test.lindsaar.net"]
mail[:to].formatted
#=> ["Mikel Lindsaar <mikel@test.lindsaar.net>"]
mail[:to].display_names
#=> ["Mikel Lindsaar"]
```

### Remaining Stuff

There are a lot of other small bug fixes, parts now get sorted
recursively on encode, body objects will accept an array of strings and
call join on them, and many other small things that are in the commit
and change logs. Check it out.

As always, tickets (and patches) are always welcome, I use [GitHub's
Tracker](http://github.com/mikel/mail/issues) for this. Or you can talk
to us on the [Mail Google
Group](http://groups.google.com/group/mail-ruby)

Happy Mailing!

blogLater

Mikel

