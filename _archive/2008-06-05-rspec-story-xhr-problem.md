---
title: "RSpec Story xhr problem "
author: Mikel Lindsaar
date: 2008-06-05
layout: post
redirect_from:
  - /2008/6/5/rspec-story-xhr-problem
---
If you are using RSpec stories (and if you are not, why not?) you might
run into this little problem. doing an xhr :post returns ArgumentError:
wrong number of arguments (4 for 3)

This happens on a simple story like this:

When "I submit a search name" do\
xhr :post, '/searches', {:search =\> {:given_name =\> "bob",
:family_name =\> "smith"}}\
end

You will get in your story output, something like this:

ArgumentError: wrong number of arguments (4 for 3)\
stories/searching_story_spec.rb:45 in "I submit a search name"

But if you look in the above xhr method, I am only using 3 arguments,
(1) a symbol \[:post\], (2) a string \['/searches'\] and a hash
\[{:search =\> {:given_name =\> "bob", :family_name =\> "smith"}}\]

What gives?!

Looking in the test.log file doesn't help either, as no exception is
raised (which is weird)

Asking on the RSpec mailing list, [Zach
Dennis](http://www.continuousthinking.com/) was good enough to give me
the solution.

Use 'xml_http_request' instead.

Apparently, there is some problem with xhr being aliased to the wrong
method somewhere internally...

Anyway, hope this helps!

Mikel

