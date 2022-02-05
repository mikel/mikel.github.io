---
title: "Updating to Rails 2.0 RC"
author: Mikel Lindsaar
date: 2007-11-21
layout: post
redirect_from:
  - /2007/11/21/updating-to-rails-2-0-rc
---
Now that Rails 2.0 is comming up... what to do and how to do it? - Note,
this has been updated to include Rails 2.0 itself...

Like any software release, Rails 2.0 is much anticipated and also going
to be one hell of a ride when it is released.

If you have hung out in #rails-contrib, or watched the
dev.rubyonrails.org Trak, then you would have seen the flurry of
activity that is happening to get Rails ready to roll out.

There is a slew of new features, which David went over on the rails
blog.

But the question really is, how and why should I update?

The second one is probably easiest to answer. Updating your base rails
gets you all the latest features and goodies that the Rails core team
and contributors have been pushing into the code. Not to mention all the
bug fixes (I maintain the TMail library which ActionMailer uses and you
definitely want the fixes in TMail if you use ActionMailer, believe me!)

So, yes. You should update.

But what is the best way to do it?

Well, this is the best procedure in my opinion.

If you are handling multiple rails sites on your development machine,
you should go ahead and upgrade them one by one.

This is because there ARE changes in the code, and things might break
unless you do it in a systematic fasion. And if you just go ahead and
update your system install of Rails, then you might end up having ALL of
your sites unusable all at the same time, JUST as the client calls in
asking for some major change.... basically, no fun at all and not the
way to spend the weekend.

So, this would be the smartest (in my opinion) way to do the updates.
Well, ok, maybe not the best, but definitely the safest :)

#### Step One

First, pick one rails app you are going to update. I know this sounds
pretty obvious, but if you have more than one, it is a good idea to pick
an app that has fairly basic features as your first step on upgrading
the lot.

#### Step Two

Then, go in and run all your specifications or tests and make sure they
pass. This is also a good opportunity to go and write those extra
tests/specs that you have been meaning to do for a while now. The ideal
scene would be a system that has everything covered by RSpec
specifications or Test::Unit tests so that you are starting with a known
datum of "This app works right now". The most frustrating thing you can
do is make a change to something that is already broken, because then
you are trying to find the fault and you don't know if it is your code
or the change to the underlying rails system.

#### Step Three

Freeze 1.2.6 in your Rails App unless you are already running 1.2.6 on
your system.

What "Freezing" does is goes and gets a full copy of Ruby on Rails and
puts it into your vendor/rails directory for your app to use. This then
means when your app starts, it will use the copy and version of Ruby on
Rails that is in your Vendor directory instead of the one that is
installed in your system.

So first, you can find out what version you are running by typing "rails
---version" at a shell or DOS prompt.

``` shell
baci:~ mikel$ rails --version
Rails 1.2.5
```

Then freeze 1.2.6 into your chosen rails app.

Freezing rails puts an entire copy of rails INTO your rails app that
your app will then use in preference to the one installed on the system.
I always unfreeze first to get rid of any other rails version in my
vendor directory:

You do this like so:

``` shell
baci:~/app_folder mikel$ rake rails:unfreeze
(in /Users/mikel/www-design/app_folder)
baci:~/app_folder mikel$ rake rails:freeze:edge TAG=rel_1.2.6
[LOTS OF OUTPUT]
```

Once you have done this, you need to update the configs. This is how you
do that:

``` shell
baci:~/app_folder mikel$ rake rails:update:configs
```

You can now run "ruby script/console" and it will tell you it is running
on Rails version 1.2.6. Well done!

One last thing is to check the config/environment.rb file. Change the
following line:

``` shell
RAILS_GEM_VERSION = '1.2.5' unless defined? RAILS_GEM_VERSION
```

to

``` shell
RAILS_GEM_VERSION = '1.2.6' unless defined? RAILS_GEM_VERSION
```

And you should be good to go.

#### Step Four

Now, go ahead and run all your tests within your app folder again. This
time, Rails will use your local copy of 1.2.6 when it is running your
tests. While this is happening you should check your development.log for
any depreciation notices.

The Rails Core team are thoughtful basically, they have put warnings
into the code of 1.2.6 to tell you about stuff that isn't going to work
in Rails 2.0. These are called depreciation notices and when you see one
in this case, work out what it is and go ahead and fix it.

Once all this is working and all your tests pass, fire up the app and
make sure it still works as expected.

#### Step Five

OK, so now you have it all working on your development computer. If all
is cool, go ahead and deploy this on the production server and make sure
IT is still working as you would expect.

In my place we have a staging server which is a production server that
is identical to the production servers (same DB and everything) but runs
separately on a privately accessible URL. This means we can do the
"final" test there before going live.

Once you have deployed it up, make sure it is all STILL working as
expected.

#### Step Six

So now you have a working production environment running Rails 1.2.6.
You have fixed any warnings that came up when you ran your app and it
all looks good. Now is the time to try and jump (on your development
computer) to Rails 2.0 RC 2.

This is how you do it.

First, you need to remove 1.2.6 from your system... so:

``` shell
baci:~/app_folder mikel$ rake rails:unfreeze
```

Now we re-freeze the rails system to 2.0.1 - It is 2.0.1 and not 2.0
because there was a small bug that the core team caught after they
released 2.0 and quickly made it into 2.0.1 to save our poor souls :)

``` shell
baci:~/app_folder mikel$ rake rails:freeze:edge TAG=rel_2-0-1
```

Now change the config/environment.rb file again from:

``` shell
RAILS_GEM_VERSION = '1.2.6' unless defined? RAILS_GEM_VERSION
```

to:

``` shell
RAILS_GEM_VERSION = '2-0-1' unless defined? RAILS_GEM_VERSION
```

Then again, do a config update:

``` shell
baci:~/app_folder mikel$ rake rails:update:configs
```

Once you have done this, you can start a console and you should see
something like this:

``` shell
baci:~/app_folder mikel$ ./script/console 
Loading development environment (Rails 2.0.1)
>>
```

The 2.0.1 means you are now running on the latest and greatest Rails!
Well done!

Now you need to start your server locally and give it a shot, see what
happens!

Really, this means repeating step four until all the tests pass again
and any development.log warnings are handled.

I hope that helps!

blogLater

Mikel

