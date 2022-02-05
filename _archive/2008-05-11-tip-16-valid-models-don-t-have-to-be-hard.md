---
title: "Tip #16 - Valid Models Don't Have to be Hard"
author: Mikel Lindsaar
date: 2008-05-11
layout: post
redirect_from:
  - /2008/5/11/tip-16-valid-models-don-t-have-to-be-hard
---
If you are using [BE DE DE](http://rspec.info/) or [TE DE
DE](http://kanemar.com/2006/03/04/screencast-of-test-driven-development-with-ruby-part-1-a-simple-example/),
then you will get situations in your specs or tests where you want to be
able to just create a valid model of another type to test against. This
is where factories and builders come in handy.

I can't really say that I can give a dissertation on what exactly makes
a factory a FACTORY or a builder a BUILDER, but what I do know is this:

When I am testing a model's interactions with another class, I like to
know that those interactions are being tested against exactly the class
that I am using in development. If the class changes and this breaks the
associations with the class I am using, then I want that test to fail
fast and to show me what is going wrong so I can fix it.

Fixtures in rails help you do this, for example, you can have a fixture:

``` yaml
# fixtures/users.yml
bob:
  name: bob
  job_id: 1

# fixtures/jobs.yml
party:
  name: Party In Charge
```

And then do a spec like this:

``` ruby

fixtures :users, :jobs

describe "A new job" do
  it "should not be an administrator" do
    @user = users(:bob)
    @job = jobs(:party)
    @user.job = @job
    @user.job.should == @job
  end
end
```

Which will pass.

but we are not testing if bob is now the Party I/C. We are just testing
to see if the user model exhibits the behaviour of having a job if it is
allocated one. We picked jobs(:party) because it was there in the YAML
file and it looked OK to use at this point of time.

Problem is if you go and modify your users model and decide that any job
that has the word 'Party' in it would not be valid, then the user spec
above would fail... for no good reason.

The problem is with fixtures is that you have to maintain them. And when
you have 20 fixtures and all you want is a valid instance of another
class, which fixture do you load? Do you want to load all those fixtures
just so you could do "\@user = User.new(valid_params)" ? Probably not.
What you want is a way just to tell your spec "Make me a new user
instance with all the defaults so I can test against it!"

Factories/Builders/Bob the Builder (or whatever you want to call them, I
like Bobs) come into play here.

With it you can do something like this:

``` ruby

describe "A new job" do
  it "should not be an administrator" do
    @user = User.build_valid
    @job = Job.build_valid
    @user.job = @job
    @user.job.should == @job
  end
end
```

And it will work... hopefully forever... but at least until you change
the way your associations work (at which point you would expect it to
fail.)

Doing it this way makes a lot of sense. What you do is assign to every
class a 'build_valid' method and a 'build_valid!' method that is
guaranteed to return a valid instance of that object, every time.

You then mix these methods into every class you have through the powers
of Ruby meta programming, and voila, you can do the above.

Now, this isn't my idea, I got it from [Paul
Gross](http://www.pgrs.net/2008/5/8/factory-pattern-with-syntactic-sugar/)
and I am going to rip his code off in the true spirit of open source :)
with a modification of my own below. The only real problem I found with
Pauls code, is that it can lead to some method name conflicts in your
ActiveRecord models, because if you had some class that was called
something that is the same name as a method name within Active record
(like class Name) then you get ALL sorts of weird errors, we fix this by
adding 'builder\_' to the front of our methods.

So without further ado:

``` ruby
# spec/factory.rb
module Factory

  def self.included(base)
    base.extend(self)
  end

  def build_valid(params = {})
    unless self.respond_to?("builder_#{self.name.underscore}")
      raise "There are no default params for #{self.name}"
    end
    new(self.send("builder_#{self.name.underscore}").merge(params))
  end

  def build_valid!(params = {})
    obj = build(params)
    obj.save!
    obj
  end

  def builder_user
    {
      :name => "Bob"
    }
  end

  def builder_job
    {
      :name => 'My Job'
    }
  end
end

ActiveRecord::Base.class_eval do
  include Factory
end
```

Then in your spec/spec_helper.rb file, somewhere near the top (after all
the other requires) put:

``` ruby
# from the project root directory.
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec'
require 'spec/rails'

# Add in the factory
require 'spec/factory'

Spec::Runner.configure do |config|
# Etc etc etc...
```

Now you can build new classes with ease.

Check out
[Paul's](http://www.pgrs.net/2008/5/8/factory-pattern-with-syntactic-sugar/)
blog on this, as he goes into detail on how you use it.

blogLater

Mikel

