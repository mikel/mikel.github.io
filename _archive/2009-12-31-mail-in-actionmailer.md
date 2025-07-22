---
title: "Mail now merged into ActionMailer"
author: Mikel Lindsaar
date: 2009-12-31
layout: home
redirect_from:
  - /2009/12/31/mail-in-actionmailer
  - /2009/12/30/mail-in-actionmailer
---
Well, it is done, Mail 1.4.2 has now been merged into ActionMailer.

Today, my fork of rails was
[merged](http://github.com/rails/rails/commit/71ffa760701d2240ece5f17b75df316611ecb3d0)
back into the rails master code branch. This removes
[TMail](http://tmail.rubyforge.org) from ActionMailer and replaces it
with my [Mail](https://lindsaar.net/2009/10/28/new-mail-gem-released)
gem.

This means that Rails 3.0 will be using Mail inside of ActionMailer
instead of TMail.

Another bit of good news is that TMail was vendor'd inside of
ActionMailer, making upgrades to TMail require a new version release of
ActionMailer. With the new changes, Mail will not be vendor'd and
instead be required as a gem. This means that you can download the
patches made to Mail and install new versions of Mail without having to
upgrade your rails stack.

As people installing Mail through Rails will quickly become the largest
volume of Mail users, I will of course check all versions of Mail with
compatibility with ActionMailer.

While the merge is done and we will have the Mail gem in Rails soon,
there is still more work to do on ActionMailer to extract out the other
"TMailisms" that had crept in over the years, code that was only there
because it was not inside of TMail. I am working to get these removed
soon and will keep you posted.

Thanks for all the people who have downloaded Mail and sent in bug
reports! Keep them coming!

blogLater

Mikel
