---
title: "Examples of Behaviour Spec'n"
author: Mikel Lindsaar
date: 2008-06-29
layout: home
redirect_from:
  - /2008/6/29/examples-of-behaviour-spec-n
---
In my previous post ([Spec Behaviour not
Implementation](https://lindsaar.net/2008/6/28/tip-27-spec-a-behaviour-not-an-implementation))
I went on a froth roll about why you should treat controller actions as
black boxes. Here I give an all to common example of why this is good
and how you *can* write specs that won't break at the most trivial
change.

``` ruby
class AddressesControler < ApplicationController
  def index
    @person = Person.find(params[:person_id])
    @addresses = Address.find_by_person_id(params[:person_id])
  end
end
```

Now obviously this should be refactored (we'll get to that in a sec) but
what are we doing here? We are assigning person to the view and the
person's addresses to the view.

Using a mocks and stubs, I might do something like this:

``` ruby
describe AddressesController do
  describe 'GET index' do

    it "should ask the Person model for a person" do
      @person = mock_model(Person)
      Person.should_receive(:find).with("1").and_return(@person)
      get :index, :person_id => 1
    end

    it "should assign a person to the view" do
      @person = mock_model(Person)
      Person.stub!(:find).and_return(@person)
      get :index, :person_id => 1
      assigns[:person].should == @person
    end

    it "should ask the Address model for the addresses" do
      Person.stub!(:find)
      @addrs = [mock_model(Address), mock_model(Address)]
      Address.should_receive(:find_by_person_id).with("1").and_return(@addrs)
      get :index, :person_id => 1
    end

    it "should assign the person's addresses to the view" do
      Person.stub!(:find)
      @addrs = [mock_model(Address), mock_model(Address)]
      Address.should_receive(:find_by_person_id).with("1").and_return(@addrs)
      get :index, :person_id => 1
      assigns[:addresses].should == @addrs
    end

  end
end
```

Now, no one would complain about that (except that it is not very dry),
pretty straight forward. But I say, my fellow RSpecers, what are we
doing poking around the internals of that controller? Why do we give two
hoots from a behavioral viewpoint on HOW the controller goes about it's
business? Can't we just assign the controller responsibility here?

Well, no, you say, I need to know it is getting the addresses properly!.
Well, ok, let's make one trivial change to one line of that controller
and see how many specs break:

``` ruby
class AddressesControler < ApplicationController
  def index
    @person = Person.find(params[:id])
    @addresses = @person.addresses
  end
end
```

Now, you would agree with me that the *external* behaviour of that
controller action has not changed, we are assigning the requested person
to the view and we are assigning the person's addresses to the view, but
guess what, **every one of our specs now fail** Why!? Because we spec'd
implementation details. We setup our stubs and mocks to provide data in
only certain ways.

The first and second specs fail because \@person is a mock model and
gets an unexpected message :addresses, the second and third specs fail
because we don't return anything from the Person.find and so you then
get nil.addresses which fails. Even if that didn't fail, we then have a
failing spec because the Address model is never called.

Evil. Madness. Insanity, but most importantly, **lost time**. Now you
need to go and dig in, remember what that spec did, what you were trying
to do and re-write the spec, hoping that you aren't changing the
required behaviour.

And what is worse, our behaviour driven development specs are failing
when the *behaviour* didn't change!

Now there is a lot to be said for mock objects and stub methods. They
are useful and have their place, they definitely speed up spec execution
time, but I think this whole thing of mock everything in the controllers
to make the specs go faster is over rated.

I work in a development team. We user [factory
objects](https://lindsaar.net/2008/5/12/tip-16-valid-models-don-t-have-to-be-hard)
and real objects when we can get away with it. And our specs run slower.
On an app that is about 50% done we have 1500 specs passing, and it
takes about 70 seconds to run them. Not too bad. About half of them use
real objects (from the database). Sure, if I went through and mocked and
stubbed everything out and spent the time doing that, it might get down
to 50 seconds, or maybe 40. But it is pretty rare that waiting for the
test suite to pass is blocking my development time.

So, if we re-wrote the above spec using factories, we would get
something like this:

``` ruby
describe AddressesController do
  describe 'GET index' do

    it "should assign the requested person to the view" do
      @person = Person.build_valid!(:id => 1)
      get :index, :person_id => 1
      assigns[:person].should == @person
    end

    it "should assign the person's addresses to the view" do
      @person = Person.build_valid!(:id => 1)
      @address = Address.build_valid(:person_id => @person.id)
      @person.addresses << @address
      get :index, :person_id => 1
      assigns[:addresses].should == [@address]
    end

  end
end
```

Now, even though we have reduced this down to two specs, in reality,
that is all the behaviour our controller is showing. It has no error
handling etc.

If there were decision path's in the behaviour of the controller, I
would stub these out to do what I wanted for the spec, like
\@person.stub!(:save).and_return(false) and the like.

One other thing that I often read is that you don't want to do a spec
like this because some other developer could go and change the
underlying API on how person and address talk to each other or what
constitutes a valid object.

Well, I work in a team and I humbly submit that:

\(a\) this doesn't happen too often, especially if you are using
factories, because if you change the valid requirements of a person,
then you should also be updating the factory.

\(b\) I want to know if my controller broke because of an API change.

Anyway, that's just how I do it, your mileage may vary.

blogLater

Mikel
