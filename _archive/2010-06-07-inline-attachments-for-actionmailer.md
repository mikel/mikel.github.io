---
title: "Inline Attachments for ActionMailer"
author: Mikel Lindsaar
date: 2010-06-07
layout: home
redirect_from:
  - /2010/6/7/inline-attachments-for-actionmailer
---
ActionMailer's support for inline attachments sucks. Totally. Until now.

If you have ever tried to get an inline attachment working in Rails 2.x
or even Rails 3 more recently, you were faced with an uphill battle that
really did not deserve to be there.

For those not in the know, an Inline attachment in an email is simply an
attachment that has a Content-Disposition of "inline" and allows you to
reference it by using an HTML image tag with its source attribute
pointing to `cid:conent-id-of-image-part`.

This allows you to put logos in your emails, header images etc. All
embedded within the email itself.

So enough talk, this is how you do it, say you have a welcome message in
your Action Mailer class, and in this welcome message you want to embed
your company logo, which is conveniently located in your Rails root
"public/images" directory.

First in your mailer, you would do:

``` ruby
class Notifier < ActionMailer::Base

  def welcome
    data = File.read(Rails.root.join('public/images/logo.png'))
    attachments.inline['logo.png'] = data
    mail
  end

end
```

Notice the [inline]{.underline} call to attachments? What this does is
tells Mail to mark this file with a content disposition of "inline"
instead of the usual "attachment".

Then in your view you would do:

``` html
<h1>Thank you for choosing ErnCorp!</h1>
<p><%= image_tag attachments['logo.png'].url -%></p>
```

Here, we are just interrogating the `mail.attachments` hash for the
attachment with the filename "logo.png" and then calling
[url]{.underline} on the attachment we fine. This generates a standard
email content ID resource locator (cid tag) that looks something like:
`cid:4c0da20e13de6@mikel.local.mail`

And that is it!

Now the cool thing about this is that when you send this email,
ActionMailer looks through your attachments list finding any inline
attachments, if it finds some, then it changes your email to a
`multipart/related` content type and then makes these attachments
available to the view through the attachments helper.

Anyway, this is now
[pushed](http://github.com/rails/rails/commit/311d99eef01c268cedc6e9b3bdb9abc2ba5c6bfa).
Enjoy and have fun!

blogLater

Mikel
