---
title: "Tip #18 - Take Back Your App Folder!"
author: Mikel Lindsaar
date: 2008-05-17
layout: home
redirect_from:
  - /2008/5/17/tip-18-take-back-your-app-folder
---
Contrary to popular (?) belief, your app folder's content is not
restricted to models, controllers, helpers and views. You can through
some other stuff in there as well!

If you have used sweepers in Rails, then you probably would have also
realised that you can put other folders that make sense into your app
folder. If you haven't used sweepers, then you probably aren't using
caching, and if you haven't used caching, you need to go and watch this
video from the Railscasts on
`<a href="http://railscasts.com/episodes/89" target="_blank">`{=html}Rails
Caching`</a>`{=html} now.

Another good example of this, is
`<a href="http://caboose.org/articles/2007/8/23/simple-presenters" target="_blank">`{=html}Rails
Presenters`</a>`{=html}.

Now, using, or not using presenters is beside the point, the point IS
that you can use your app directory for **GASP** *YOUR* application
code!

Why do I bring this up?

Well, it is because of the often misused (in my opinion)
\$RAILS_ROOT/lib folder.

In my opinion, the \$RAILS_ROOT/lib folder, should be for Ruby code that
comes from an external source, or something that your application uses
as an external action. Ideally, you would have in the \$RAILS_ROOT/lib
folder, code that someone else has written and tested as working
somewhere else. Off course, it could also be code YOU have written and
tested elsewhere, but it remains that it is code that is not strictly
part of your app, but your app uses it.

Then however, you can have a problem, where would you put code that does
not specifically relate to a model, but DOES relate to your app and is a
critical part of your app that you need to use and refer to from your
models? What sort of stuff would this be?

Well, in my app, I generate PDFs, these are pre made PDFs that are for a
very specific and unique task. To make this sane, I make a
generate\_#{name}\_pdf.rb file for each one.

Where do I put these?

Well, in the \$RAILS_ROOT/app/lib/ folder! It doesn't exist? Fine, add
it!

Once you add it though, you need to tell rails about it so that the
files in there get included in the load path. This is quite easy, whack
open your environment.rb file and put in:

``` ruby
Rails::Initializer.run do |config|
  config.load_paths << "#{RAILS_ROOT}/app/lib"
end
```

(Obviously, don't delete what is already in the Initializer block, I
just put the block there for context, just add the line).

Then, once you have done that, you can put your application specific non
rails ruby files into the lib directory where they belong.

As an added bonus, when you are in one of these files you can Ctrl-Shift
Down Arrow and you will jump to your Rspec spec for the file which will
be in specs/lib/filename_spec.rb and this will all work as well.

blogLater

Mikel
