---
title: "New ActionMailer API in Rails 3.0"
author: Mikel Lindsaar
date: 2010-01-26
layout: home
redirect_from:
  - /2010/1/26/new-actionmailer-api-in-rails-3
---
Action Mailer has long been the black sheep of the Rails family.
Somehow, through many arguments, you get it doing exactly what you want.
But it takes work! Well, we just fixed that.

Action Mailer now has a new API.

But why? Well, I had an itch to scratch, I am the maintainer for TMail,
but found it very hard to use well, so I sat down and wrote a really
Ruby Mail library, called, imaginatively enough,
[Mail](https://lindsaar.net/2010/1/23/mail-gem-version-2-released)

But Action Mailer was still using TMail, so then I replaced out [TMail
with Mail in Action
Mailer](https://lindsaar.net/2009/12/30/mail-in-actionmailer)

And now, with all the flexibility that Mail gives us, we all thought it
would be a good idea to re-write the Action Mailer DSL. So with a lot of
ideas thrown about between David, Yehuda and myself, we came up with a
great DSL.

I then grabbed [José Valim](http://blog.plataformatec.com.br/) to pair
program together (with him in Poland to me in Sydney!) on ripping out
the guts of Action Mailer and replacing it with a lean, mean mailing
machine.

This was
[merged](http://github.com/rails/rails/commit/abad097016bf5243e9812f6a031f421a986b09f7)
today.

So what does this all mean? Well, code speaks louder than words, so:

### Creating Email Messages:

Instead of this:

``` fixed
 class Notifier < ActionMailer::Base
   def signup_notification(recipient)
     recipients      recipient.email_address_with_name
     subject         "New account information"
     from            "system@example.com"
     content_type    "multipart/alternative"
     body            :account => recipient

     part :content_type => "text/html",
       :data => render_message("signup-as-html")

     part "text/plain" do |p|
       p.body = render_message("signup-as-plain")
       p.content_transfer_encoding = "base64"
     end

     attachment "application/pdf" do |a|
       a.body = generate_your_pdf_here()
     end

     attachment :content_type => "image/jpeg",
       :body => File.read("an-image.jpg")

   end
 end
```

You can do this:

``` fixed
class Notifier < ActionMailer::Base
  default :from => "system@example.com"

  def signup_notification(recipient)
    @account = recipient

    attachments['an-image.jp'] = File.read("an-image.jpg")
    attachments['terms.pdf'] = {:content => generate_your_pdf_here() }

    mail(:to => recipient.email_address_with_name,
         :subject => "New account information")
  end
end
```

Which I like a lot more :)

Any instance variables you define in the method become available in the
email templates, just like it does with Action Controller, so all of the
templates will have access to the \@account instance var which has the
recipient in it.

The mail method above also accepts a block so that you can do something
like this:

``` fixed
def hello_email
  mail(:to => recipient.email_address_with_name) do |format|
    format.text { render :text => "This is text!" }
    format.html { render :text => "<h1>This is HTML</h1>" }
  end
end
```

In the same style that a respond_to block works in Action Controller.

### Sending Email Messages:

Additionally, sending messages has been simplified as well. A
Mail::Message object knows how to deliver itself, so all of the delivery
code in Action Mailer was simply removed and responsibility given to the
Mail::Message.

Instead of having magic methods called deliver*\* and create*\* we just
call the method which returns a Mail::Message object, and you just call
deliver on that:

So this:

``` fixed
Notifier.deliver_signup_notification(recipient)
```

Becomes this:

``` fixed
Notifier.signup_notification(recipient).deliver
```

And this:

``` fixed
message = Notifier.create_signup_notification(recipient)
Notifier.deliver(message)
```

Becomes this:

``` fixed
message = Notifier.signup_notification(recipient)
message.deliver
```

You still have access to all the usual types of delivery agents though,
:smtp, :sendmail, :file and :test, these all work as they did with the
prior version of ActionMailer.

### Receiving Emails

This has not changed, except now you get a Mail::Message object instead
of a TMail object.

Mail::Message will be getting a :reply method soon which will
automatically map the Reply related fields properly. Once this is done,
we will re-vamp receiving emails as well to simplify.

### Old API

And... of course, if you still "like the old way", the new Action Mailer
still supports the old API and all the old tests still pass. We have
moved everything relating to the old API into deprecated_api.rb and this
will be removed in a future release of Rails.

### Summary

With Mail and this refactor, Action Mailer has now finally become just a
DSL wrapper between Mail and Action Controller.

blogLater

Mikel
