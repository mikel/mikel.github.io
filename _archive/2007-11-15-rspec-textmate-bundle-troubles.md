---
title: "RSpec Textmate Bundle Troubles"
author: Mikel Lindsaar
date: 2007-11-15
layout: home
redirect_from:
  - /2007/11/15/rspec-textmate-bundle-troubles
---
I love RSpec, I love textmate... but sometimes... they just don't love
each other...

Two days ago I updated my gems.

Somehow, I managed to get the RSpec 1.1.0 Gem installed. It is not in
the repository any more, so beats me how I managed to get it.

But it caused me all sorts of problems.

I was getting this error:

/Users/mikel/Library/Application Support/TextMate/Pristine
Copy/Bundles/Ruby RSpec.tmbundle/Support/lib/spec_mate.rb:47:in \`run':
wrong number of arguments (5 for 1) (ArgumentError) from
/Users/mikel/Library/Application Support/TextMate/Pristine
Copy/Bundles/Ruby RSpec.tmbundle/Support/lib/spec_mate.rb:47:in \`run'
from /Users/mikel/Library/Application Support/TextMate/Pristine
Copy/Bundles/Ruby RSpec.tmbundle/Support/lib/spec_mate.rb:46:in \`chdir'
from /Users/mikel/Library/Application Support/TextMate/Pristine
Copy/Bundles/Ruby RSpec.tmbundle/Support/lib/spec_mate.rb:46:in \`run'
from /Users/mikel/Library/Application Support/TextMate/Pristine
Copy/Bundles/Ruby RSpec.tmbundle/Support/lib/spec_mate.rb:30:in
\`run_focussed' from /tmp/temp_textmate.OBOZQv:4

I looked around EVERYWHERE I could on the net and searched google to no
avail, until I saw this comment from Mr RSpec himself, [David
Chelimsky](http://blog.davidchelimsky.net/)

> It would be less frustrating if you use the same release of rspec and
> the TM bundle!

Heh...

I wonder if that could POSSIBLY apply to MY situation?? Surely not! :)

Anyway, so this is what I went and did... and it is basically a surefire
way to handle the problem:

``` shell
baci:~ mikel$ cd /Users/mikel/Library/Application\ Support/TextMate/
Pristine\ Copy/
baci:~ mikel$ rm -rf Ruby\ RSpec.tmbundle/
baci:~ mikel$ sudo gem uninstall rspec
baci:~ mikel$ sudo gem install rspec
Need to update 32 gems from http://gems.rubyforge.org
................................
complete
Successfully installed rspec-1.0.8
Installing ri documentation for rspec-1.0.8...
Installing RDoc documentation for rspec-1.0.8...
```

Then go into Textmate and using the trusty GetBundle bundle, get the
Ruby RSpec bundle.

Once this finishes, try running your specs and you should be OK... and
our two favorite tools will show love for one another again!

blogLater

Mikel
