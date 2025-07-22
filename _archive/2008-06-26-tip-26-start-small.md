---
title: "Tip #26 - Start Small"
author: Mikel Lindsaar
date: 2008-06-26
layout: home
redirect_from:
  - /2008/6/26/tip-26-start-small
  - /2008/6/24/tip-26-start-small
---
If you are getting frustrated with RSpec, then you have probably skipped
a gradient. Start smaller!

When I was trying to teach a co-worker how to write specs, I ran into a
gradient problem. He was trying to write specs for an existing app and
controller setup that had the usual create action in the controller, it
also had a before filter checking logins and timezones, the controller
action was simple enough, something like this:

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

Now, if you are really starting out, don't start with this. Start with
something MUCH simpler... maybe like this:

``` ruby
def new
end
```

That would be a good gradient :)

No, seriously, if you just "don't get RSpec", then you skipped a
gradient or went past something you don't understand. Go back to an
earlier gradient and come forward again.

I can say without a doubt that the #1 problem that new RSpec users have
is code that tries to do too much.

Let the code evolve step by step from NOTHING and then come forward, the
RSpec webpage has it right when it says "take very small steps".

The skipped gradient problem is hard enough for experienced RSpec coders
trying to fix an existing broken spec, but for someone who hasn't
understood the basics of how RSpec works, it is simply a killer. You
don't want to be wondering if your use of response.should
have_tag('div', 2) is correct when all the specs are not working and you
have red failing tests everywhere... "Thar b' dragn's thar matey!"

If you run into this problem, then go make a new scratch app and start
specing it from the ground up, with minimal code generation.

Something like this:

``` sh
baci:test mikel$ ./script/generate rspec_controller welcome
      exists  app/controllers/
      exists  app/helpers/
      create  app/views/welcome
      exists  spec/controllers/
      exists  spec/helpers/
      create  spec/views/welcome
      create  spec/controllers/welcome_controller_spec.rb
      create  spec/helpers/welcome_helper_spec.rb
      create  app/controllers/welcome_controller.rb
      create  app/helpers/welcome_helper.rb
```

Now go into the spec/controllers/welcome_controller_spec.rb and check it
out:

``` ruby
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe WelcomeController do

  #Delete this example and add some real ones
  it "should use WelcomeController" do
    controller.should be_an_instance_of(WelcomeController)
  end

end
```

Your standard RSpec template. This is good enough to start. We are going
to build a welcome page here, so lets write our first spec:

``` ruby
describe "getting the home page of the site" do
  it "should be a success" do
    get :index
    response.should be_success
  end
end
```

And stop RIGHT THERE and run your specs, it will fail because no index
action or template exists yet. Once it has failed, do the next smallest
thing that could possibly pass. Write an empty index action:

``` ruby
class WelcomeController < ApplicationController
  def index
  end
end
```

And then run your specs, it will now pass. Good! Now you can start
building on that stable datum of 'it is passing now, if I add this *one*
thing it should fail, then if I code this *one* thing, then it will pass
again.'

While I am at it, ban the script/generate rspec_scaffold command from
your development vocabulary until you know how to do every step in the
code that the scaffold generates (and even then, the use is
questionable). The great thing that the scaffold does is provide
examples. If you are new to RSpec, you might be tempted to use the
scaffold, I would recommend instead to make a scratch up, and use the
scaffold there, and then use the code examples step by step in your own
app building up your own specs.

This will give you a *much* broader understanding of how RSpec works.

Trying to spec some huge pre-existing code block as your introduction to
RSpec is not impossible, but it is a pretty steep gradient and will
result in more hair loss than passing specs.

blogLater

Mikel
