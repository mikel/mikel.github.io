---
title: "TMail 1.2.0 Released!"
author: Mikel Lindsaar
date: 2007-12-01
layout: home
redirect_from:
  - /2007/12/1/tmail-1-2-0-released
---
TMail 1.2.0 is now out. Here are the gory bits:

So, I just published TMail 1.2.0 on
[RubyForge](http://tmail.rubyforge.org/)

What is in 1.2.0?

A couple of important fixes actually.

1.  TMail now returns a TMail::Mail object when you are asking it to
    create a forward email, before it basically returned nothing, which
    is basically useless :) Now it returns a new email object that has
    the original email bundled up as a forwarded email. Then all you
    need to do is add a to, from, etc and send it. Neat.
2.  When you ask an TMail::Mail object for it's reply_addresses, it
    returns an empty array if reply_to is set to nil. This is fixed.
3.  If you use the scanner.rb file instead of the C extension (which is
    anyone using TMail inside of ActionMailer) then there was an
    introduced bug of adding a @ into the ATOM characters definition.
    This isn't per RFC, and actually breaks other tests. This was nuked
    (also Mail.app, which was the cause of this patch in the first
    place, has since been fixed and no longer leaves unquoted naked @'s
    in the From field... so we really don't need this any more).

In addition to the above patches, we did the following:

1.  Upgraded the documentation, I updated about 500 lines of docs in the
    TMail::Mail public methods file. You should see some of my work in
    the RDocs.
2.  Removed out the custom Base64.c parser, we don't need it as the Ruby
    Base64 parser is just as fast.
3.  Added the ability for the TMail::Mail#sender method to have a
    default value, like all the other methods.

All in all, a good release I think.

I hope you all can use it for good as well :)

blogLater

Mikel
