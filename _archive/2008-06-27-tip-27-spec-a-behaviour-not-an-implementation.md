---
title: "Tip #27 - Spec a Behaviour, Not an Implementation"
author: Mikel Lindsaar
date: 2008-06-27
layout: home
redirect_from:
  - /2008/6/27/tip-27-spec-a-behaviour-not-an-implementation
---
This has been said a lot, and doesn't really need repeating by someone
like me, but, as this is a tips page, I should put it here.

What does this mean? Behaviour, not Implementation?

Well, it means, what is it you are expecting your code to achieve? What
is the end product that your code is meant to do? What are the valid
states your code can be in *after it has finished executing*?

The way I draw the line on this is, except for RARE cases, I only spec
the public interface of a component. That is, the bits that the class is
presenting out to the bad wide world as valid ways to communicate to it.
If you do this, it means that later you can change your implementation
of HOW you got something done without a bunch of specs failing.

The applies to controller specs.

You should really treat the insides of a controller as sacrosanct, you
don't really have any business hunting and poking around in there, each
controller has a right to privacy, **THEY HAVE RIGHTS TOO!...**

Ok, maybe a bit carried away, but you might see what I mean in a sec:

``` ruby
def create
  @person = Person.new(params[:person])

  respond_to do |format|
    if @person.save
      flash[:notice] = 'Person was successfully created.'
      format.html { redirect_to(@person) }
      format.js
    else
      format.html { render :action => "new" }
      format.js
    end
  end
end
```

With this simple example, what is it we are actually trying to spec?

Well, what is the behaviour?

1\. If it succeeds, then we should get a flash sent to the view telling
us we were a good little user.

2\. If it succeeds, then we'll get sent to the person show page

3\. If it succeeds and we did an XHR request, then we'll get the
create.js template

4\. If it succeeds we should get a person instance assigned to the view
that has been saved.

5\. If it fails on a HTTP request, then we get the new template rendered

6\. If it fails on an XHR request, then we'll still get the create.js
template

7\. If it fails then we should get a person instance assigned to the
view that has not been saved.

And that's it.

You don't want to get into what params are being assinged to the person
model on the new action, you don't want to get into if the person model
receives the wrong number of values for the new action, or anything like
that.

Why? Because what the model does with the params is really no business
of the controller. It is not the controller's responsibility. All the
controller wants to know is **"Did it save or not?"**

In fact, I would argue that no where in your spec for the controller
would you have
"\@person.should_receive(:save).with(some_params).and_return(true)", no,
it is implementation detail, evil.

Ideally (though this is hard to achieve in practice) you want to try and
treat each executable code block as a black box in terms of describing
behaviour.

You want to know "If I feed it XYZ, then the result will be ABC". You

*don't* want to get into 'If I feed it XYZ, then I need to make sure it
will do A through Z so that I can then test to see if it actually did
ABC'

See the difference? The first viewpoint allows you to refactor away
inside the discrete code block (the create action in this case), but the
second requires your behaviour specification code know every minute
detail about your code execution, and that my friends is about as
brittle as a 10,000 line PHP page.

**Use 'shoulds' for specifying behaviour and use 'stubs' for dictating
code execution paths.**

if you did that, your specs would look something like this:

``` ruby
describe "create action" do

  def doing_a_successful_save
    @person = mock_model(Person, :save => true, :new_record? => false)
    Person.stub!(:new).and_return(@person)
  end

  def doing_a_failed_save
    @person = mock_model(Person, :save => false, :new_record? => true)
    Person.stub!(:new).and_return(@person)
  end

  describe "successful request" do
    it "should flash a notice to the user that the create succeeded" do
      doing_a_successful_save
      post :create
      flash[:notice].should == "Person was successfully created."
    end

    it "should assign a person instance to the view" do
      doing_a_successful_save
      post :create
      assigns[:person].should == @person
    end

    it "should render the show template for HTTP Request" do
      doing_a_successful_save
      post :create
      response.should render_template('show')
    end

    it "should render the create template for XH Request" do
      doing_a_successful_save
      xhr :post, :create
      response.should render_template('create')
    end

    it "should assign a saved person instance to the view" do
      doing_a_successful_save
      post :create
      assigns[:person].should_not be_new_record
    end
  end

  describe "failed request" do
    it "should return the new template for HTTP Request" do
      doing_a_failed_save
      post :create
      response.should render_template('new')
    end

    it "should return the create template for Ajax Request" do
      doing_a_failed_save
      xhr :post, :create
      response.should render_template('create')
    end

    it "should not save the object" do
      doing_a_failed_save
      post :create
      assigns[:person].should be_new_record
    end
  end

end
```

BDD is a discipline. Getting your head around it really starts with
understanding the basic underlying principles of WHY you are doing it.

BDD stands for Behaviour Driven Development. So stick with that and
nothing more and you will find BDD a *lot* easier to get done.

blogLater,

Mikel
