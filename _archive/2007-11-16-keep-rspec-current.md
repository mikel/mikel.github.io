---
title: "Keep RSpec Current"
author: Mikel Lindsaar
date: 2007-11-16
layout: post
redirect_from:
  - /2007/11/16/keep-rspec-current
  - /2007/11/15/keep-rspec-current
---
I like living on the edge with RSpec. It actually is not so bad. Every
week or so I do an update on the trunk, but this is a few steps that
should be automated, this is how you do it.

The steps involved are:

1.  Get the latest copy of the RSpec trunk
2.  Build the gem
3.  Install the gem
4.  Install the latest Textmate bundle

This is something perfectly suited to a shell script.

Thanks go to [Ashley Moran](http://aviewfromafar.net/) for giving me the
idea to write this blog entry on the RSpec mailing list.

So, this is how I set it up and then do it.

```{=html}
<ol>
```
```{=html}
<li>
```
Make a directory where you are going to keep your source tree for RSpec,
I keep mine in "Ruby Programs"

```{=html}
</li>
```
``` shell
baci:~ mikel$ mkdir ruby_programs
```

```{=html}
<li>
```
Then check out the RSpec trunk into this directory

```{=html}
</li>
```
``` shell
baci:~ mikel$ cd ruby_programs
baci: mikel$ svn co http://rspec.rubyforge.org/svn/trunk/RSpec
```

```{=html}
<li>
```
Next step is to remove any other version of the RSpec.tmbundle you might
have on your computer, you should check the following areas:

```{=html}
</li>
```
``` shell
~/Library/Application\ Support/TextMate/Bundles/
~/Library/Application\ Support/TextMate/Pristine\ Copy/Bundles/
/Library/Application\ Support/TextMate/Bundles/
/Library/Application\ Support/TextMate/Pristine\ Copy/Bundles/
```

```{=html}
<li>
```
Now we have a directory tree, lets make a shell script to handle the
work

```{=html}
</li>
```
In your favorite editor, type the following:

``` shell
#!/usr/bin/env sh
cd ~/ruby_programs/rspec/rspec/
rake clobber
rake package
sudo gem install pkg/*.gem
```

As a note, prefixing a path with "\~" is shorthand to insert the path to
your home directory, which in my case is /Users/mikel/

```{=html}
<li>
```
You can save the above code in your home directory, call it
RSpec_update.sh, you also need to make it executable by doing the
following:

```{=html}
</li>
```
``` shell
chmod 775 ~/RSpec_update.sh
```

```{=html}
<li>
```
Now run the command, watch the text fly by, enter your password where
needed and you would have updated your RSpec bundle, gem and docs all in
one swoop!

```{=html}
</li>
```
```{=html}
</ol>
```
Enjoy!

blogLater

Mikel

