---
title: "Put your mailer where the action is! "
author: Mikel Lindsaar
date: 2010-03-02
layout: home
redirect_from:
  - /2010/3/2/put-your-mailer-where-the-action-is
---
Recently I was pointed at an article by [Robby on
Rails](http://www.robbyonrails.com/articles/2009/11/16/sending-email-controllers-versus-models)
which discussed where mailers belong. Well, after reading the amazingly
long discussion, I feel the solution is quite simple.

-   Put it in the controller if the primary action depends on sending
    email.
-   Put it in a callback if the email is a byproduct.

But first a little history. ActionMailer has been rewritten, almost from
the ground up. It now inherits from AbstractController, and is the same
sort of beast as one of your view controllers. In fact, it uses the same
render calls that your average controller does and as far as Rails is
concerned, it is just another controller, except it renders email
instead of web pages.

Controllers when they are processing a request from a user, control the
action. They decide what models get queries, what files or images get
sent and what access the users can and can't have. This is all decided
in the controller.

ActionMailer is just another controller, it is much more a controller
than a model. So if it is just a controller, we should treat it as one!

But what do I mean above by "a primary action"? Well, take a new user
signing up and needing to click on an registration link, the controller
should be responsible for getting the email sent:

``` ruby
class UsersController < ActionController::Base
  def create
    # ...
    if @user.save
      Notifier.deliver_verification_email
      flash[:notice] = "Please check your inbox..."
      redirect_to home_path
    else
    # ...
  end
end
```

Here the primary action of this user is to get a new account, and part
of that is the verification email, in fact, a big part of that. So much
so that if they don't get that email, then they don't get an account.

What about another primary action? Well, password reset is a perfect
example:

``` ruby
class PasswordsController < ActionController::Base
  def destroy
    user = User.find_by_email(params[:email])
    Notifier.deliver_password_reset(user)
    flash[:notice] = "Please check your inbox..."
    redirect_to home_path
    # ...
  end
end
```

Again, here we have a controller who is handling a request from a user
who wants to receive an email. The primary purpose here is to deliver
that email. Why make a whole complex call back? The logic is simple,
clear and easy to follow.

But by-product emails are another thing.

At [RailsPlugins.org](http://railsplugins.org/), we have it hooked up to
RubyGems.org so that if you push a new gem version to RubyGems, and you
have that same gem listed and 'linked' in RailsPlugins, then that new
version will be automatically created for you on RailsPlugins with all
the previous version's compatibility matrix, oh, and by the way, the
RailsPlugins app will send you an email to let you know.

That is the key phrase though, to let you know.

If the email doesn't get sent, it's not the end of the world. It is not
a primary action. It will not destroy the integrity of your database. In
fact, it may not even be noticed if it was missing. So putting this into
the model, or as a call back is perfectly valid.

Another by-product email would be notifications to everyone watching a
comment thread. Again, this is dependent on the model being saved, the
comment being valid, and, oh, we'll send out a notification to all our
users. The email is not the primary part of the app, and would be
clutter in the controller. Another perfect example of a mailer that can
go into an observer, call back or the model itself.

The bottom line is, it is not a religious war, put your mailers where
they make sense.

But with ActionMailer now effectively just another controller, use it as
one!

blogLater

Mikel
