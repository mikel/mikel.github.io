---
title: "Tip #24 - Being clever in specs is for dummies"
author: Mikel Lindsaar
date: 2008-06-23
layout: home
redirect_from:
  - /2008/6/23/tip-24-being-clever-in-specs-is-for-dummies
---
This tip is coming to you from a frustrated developer having to read
someone else's specs....

RSpec is a wonderful tool.

In the right hands, it makes behavior driven development almost natural.
It definitely makes producing readable specifications possible and
allows you to stop focusing and worrying about writing your
specifications, and just get on with life and livingness.

Another wonderful tool is the DRY principle.

The idea of the DRY (Don't Repeat Yourself) principle is that every
datum in your system that you are programming, and every procedure,
should be defined and delimited to one location in your code / system
structure. This is a wonderful principle that allows you later to make
changes to your code with simplicity and aplomb, as you only have to
look in location A to find all the code relating to A. You don't have to
look in A, then repeat your change 15 times in different locations in A
all to fix one small part of the code.

You know unDRY code, you have all seen it. It's like someone crossed a
big 1980's BASIC for loop with a code generator and let it loose in your
app folder. It isn't pretty and it is a pain to maintain.

However...

Being crispy DRY is the WRONG tool to apply to writing SPECS.

What do I mean?

Well, consider this (simple) controller example:

``` ruby
it "should redirect if we are not logged in" do
  get :index
  response.should redirect_to login_path
end
```

Simple, this just ensures that the response from the server when we are
requesting the index action in the current controller will be a redirect
to the login page.

Now, we keep coding and we get:

``` ruby
it "should redirect if we are not logged in" do
  get :index
  response.should redirect_to login_path
end

it "should let us see the index if we are logged in" do
  session[:logged_in] = true
  session[:user_id] = 99
  get :index
  response.should be_success
end

it "should render the index template if we are logged in" do
  session[:logged_in] = true
  session[:user_id] = 99
  get :index
  response.should render_template('people/index')
end
```

Now, this is where the DRY-o-meter in your head starts going, "Err...
Mikel, are you on drugs or what, why not put that logged in thing into a
before call?!"

Why? Well, I think it is the wrong place for it, but to humour you, lets
try that:

``` ruby
describe "when not logged in" do
  it "should redirect if we are not logged in" do
    get :index
    response.should redirect_to login_path
  end
end

describe "when logged in" do
  before(:each) do
    session[:logged_in] = true
    session[:user_id] = 99
  end

  it "should be a success" do
    get :index
    response.should be_success
  end

  it "should show the index template" do
    get :index
    response.should render_template('people/index')
  end
end
```

OK, now you DRY-gurus can cast an evaluative eye over that and grant it
a stamp of approval.. except (you all say) that get :index is a bit of a
give away, can't we put that in the before call as well?

Well....err... yeah... I guess so... lets try that:

``` ruby
describe "when not logged in" do
  it "should redirect if we are not logged in" do
    get :index
    response.should redirect_to login_path
  end
end

describe "when logged in" do
  before(:each) do
    session[:logged_in] = true
    session[:user_id] = 99
    get :index
  end

  it "should be a success" do
    response.should be_success
  end

  it "should render the index template" do
    response.should render_template('people/index')
  end
end
```

**THERE!** you shout, **THAT IS DRY!**

And you are right, it is DRY, nothing is repeated.

But you know what? It is also unmaintainable and will be a nightmare in
a few months when you look back on it.

Right now, it isn't a problem, after all, it is only 22 lines of code
and you can see everything, but sooner or later, that controller spec
could get up to a few hundred lines line, and then you, my dry friend,
are up the DRY creek without so much as a paddle. Because when you go to
fix the line 'it should redirect if we are not logged in', you are going
to have to go hunting up through the before call chain (which could be
several levels deep) keeping track of instance variables, session state
and any other cobweb that has been inserted in there, and find what in
blazes is going on.

Of course the above example is simplistic. But I am sure you can agree
that looking at a spec that tells you NOTHING about the context or scope
it is running in is useful for a computer, and saves some hard drive
space, but basically useless for you, and really, that is who matters,
the programmer.

Here is a tip:

Before calls are to set up and clean up your testing environment, they
are not there to setup up your testing expectations

Valid use of a before call? Making sure some directories that you are
about to create in a test suite are not there. Valid use of an after
call? Ensuring that the directories you made in the test suite are no
longer there.

That is, anything that your program is not designed to handle or is not
part of the specification, can go into the before or after calls....

N-O-T-H-I-N-G&nbsp;  E-L-S-E

Get the drift?

It might seem harsh, but believe me, you will thank me when you are 6
months down the track and come back to it...

So, if you can't use before and after, what are you to do? Well, the
simple solution is to explicitly call inline helper methods... lets
refactor our code above:

``` ruby
describe "when not logged in" do
  it "should redirect if we are not logged in" do
    get :index
    response.should redirect_to login_path
  end
end

describe "when logged in" do
  def given_a_logged_in_user
    session[:logged_in] = true
    session[:user_id] = 99
  end

  it "should let be a success" do
    given_a_logged_in_user
    get :index
    response.should be_success
  end

  it "should render the index template" do
    given_a_logged_in_user
    get :index
    response.should render_template('people/index')
  end
end
```

There.

Now, we have added 3 lines of code and made it **much** clearer. Why?
Because now you don't have to make the mental note of 'oh, before this
spec runs, I set the session params to log in the user' instead, it is
right there in the spec.

I have taken the given syntax from Story running, I like it. And
further, you can just read that code.

When you come back to it in 6 months, you can look at it and instantly
see what is going on, with NOTHING left out.

Anyway, end of rant... I'm off to refactor some 4 deep nested before
calls....

blogLater

Mikel
