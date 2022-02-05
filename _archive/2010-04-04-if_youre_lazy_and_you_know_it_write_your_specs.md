---
title: "If you're lazy and you know it write your specs!"
author: Mikel Lindsaar
date: 2010-04-04
layout: post
redirect_from:
  - /2010/4/4/if_youre_lazy_and_you_know_it_write_your_specs
---
You need to sing that title along to [this
tune](http://www.youtube.com/watch?v=zhwHtw9b_5U) but it struck me as a
great idea for a post.

As you probably all know, I code the Mail library for Ruby. When I
announced my intentions to the TMail mailing list last year, I had a
bunch of people say "Don't bother, it's too big a job" or "just wrap the
libmime library". But I decided to try it out, I mean, how hard could it
be?

Hard.

No really. It's a real pain covering all the edge cases. Email is
probably one of the most abused specifications out there, actually. No.
I think it is THE most abused specification out there. Even the worst
HTML pages are better put together than your average spam email. And
there are millions of spam emails.

But when I started on Mail, I made a conscious decision to spec first
the entire library, and as it stands today, there are over 1300 specs in
Mail.

The first spec I wrote was actually this one (which is still in the
library):

``` ruby
describe "mail" do
  it "should be able to be instantiated" do
    doing { Mail }.should_not raise_error
  end
end
```

One of the more narly ones is:

``` ruby
it "should handle |Pete(A wonderful ) chap) <pete(his account)@silly.test(his host)>|" do
  address = Mail::Address.new('Pete(A wonderful \) chap) <pete(his account)@silly.test(his host)>')
  address.should break_down_to({
      :name         => 'Pete',
      :display_name => 'Pete',
      :address      => 'pete(his account)@silly.test',
      :comments     => ['A wonderful \\) chap', 'his account', 'his host'],
      :domain       => 'silly.test',
      :local        => 'pete(his account)',
      :format       => 'Pete <pete(his account)@silly.test> (A wonderful \\) chap his account his host)',
      :raw          => 'Pete(A wonderful \\) chap) <pete(his account)@silly.test(his host)>'})
end
```

What has this got to do with being lazy? Easy, if you have a full spec
(or test) suite and you change something, you can track the impact there
is on the entire library.

So when I get an email that breaks mail, I load it into the spec suite,
and run it, get a failure, then go ahead and change code with aplomb,
each time running the specs.

There is a huge sense of security knowing you have thorough spec
coverage.

I have another application, consisting of over 50,000 lines of code
(combined specs, features and code itself) which I wrote for a client. I
had to go back to it 7 months after I wrote it (having basically not
touched it for this time) and add a new feature.

The first thing I did was make sure the spec suite was running. It was,
mostly, another coder had made some changes and not updated the specs
and features, so there were a few failures. So I got to work and got it
green.

Then making the change was trivial, I didn't have to worry too much
about unintended consequences as I know the spec and feature set was
very thorough. The client is also rewarded with a highly maintainable
application that is mostly error free and has been running happily
along.

The point is, that if you are not thorough writing test / specs /
features with your Rails app. Then you are not doing your job in a
professional manner, simple as that.

But the good point is, if you like being lazy (and not having to spend

*HOURS* trying to debug the latest problem with your code), write your
specs and features as you go. You will save yourself (and your client /
boss / life) countless hours of frustration.

blogLater

Mikel

