---
title: "Our Rails Rumble Entry - StillAlive.com"
author: Mikel Lindsaar
date: 2010-10-19
layout: post
redirect_from:
  - /2010/10/19/our-rails-rumble-entry-stillalive.com
---
[StillAlive.com](http://stillalive.com/) is our RailsRumble entry, and I
am quite happy with it!

StillAlive does app monitoring with a twist. Instead of just pinging
your server, or checking for a string on a page, you can write cucumber
like stories that interrogate your app and test that it is actually
working.

For example, for [TellThemWhen](http://tellthemwhen.com/) I have the
following story:

-   When I go to http://tellthemwhen.com/
-   And I follow "Make a Time!"
-   Then I should see "Create Notification"
-   When I fill in "Time" with "Tomorrow"
-   And I fill in "Title" with "Test Notification"
-   And I fill in "Message" with "This is the message in the
    notification"
-   And I press "Create Notification"
-   Then I should see "Test Notification"
-   And I should see "This is the message in the notification"

StillAlive will then run that script every hour and email and SMS me if
it fails....

And the awesome thing is, we did this in 48 hours... 4 guys... and we
even slept some!

Ruby on Rails truly is an awesome development environment.

Please try it out and let me know what you think.

Mikel

