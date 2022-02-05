---
title: "Feedburner Site Stats on Mephisto"
author: Mikel Lindsaar
date: 2007-12-09
layout: post
redirect_from:
  - /2007/12/9/feedburner-site-stats-on-mephisto
---
If you use Feedburner and want to use Site Stats, there isn't a ready
made template, this is how you do it.

Feedburner expects a script in the following format:

(line wrap marked '%\\')

``` html
<script src="http://feeds.feedburner.com/~s/lindsaar-net?%\
i=http://url_to_track"
type="text/javascript" charset="utf-8">
</script>
```

So, how do you drop in the URL of the page you are in in Mephisto? Very
easy, you use the article.url drop.

So the code becomes:

(line wrap marked '%\\')

``` html
<script src="http://feeds.feedburner.com/~s/lindsaar-net?%\
i=http://lindsaar.net{{ article.url }}"
type="text/javascript" charset="utf-8">
</script>
```

This way, when you are on your home page, aricle.url returns nil and
liquid converts that to an empty string which leaves you with your main
homepage URL, and when you are on a sub page, returns the permalink of
that page.

I like Mephisto :)

blogLater

Mikel

