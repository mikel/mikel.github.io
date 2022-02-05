---
title: "Interesting method definition in ruby"
author: Mikel Lindsaar
date: 2007-11-18
layout: post
redirect_from:
  - /2007/11/18/interesting-method-definition-in-ruby
---
Today, while doing some documentation on the TMail library, I found an
interesting method declaration in the interface.rb file that has me
stumped...

Here it is:

``` ruby
def mime_version=( m, opt = nil )
  if opt
    if h = @header['mime-version']
      h.major = m
      h.minor = opt
    else
      store 'Mime-Version', "#{m}.#{opt}"
    end
  else
    store 'Mime-Version', m
  end
  m
end
```

Got any ideas on how do you call this method and pass a value to opt?

One possible way would be:

``` ruby
send('mime_version=', "1", "2")
```

Got any others?

