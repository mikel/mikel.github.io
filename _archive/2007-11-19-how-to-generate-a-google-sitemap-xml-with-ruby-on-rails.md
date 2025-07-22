---
title: "How to generate a Google sitemap.xml with Ruby on Rails "
author: Mikel Lindsaar
date: 2007-11-19
layout: home
redirect_from:
  - /2007/11/19/how-to-generate-a-google-sitemap-xml-with-ruby-on-rails
---
If you use Google webmaster tools, you would have used the sitemap.xml
file to tell Google about the pages your site has. While there are tools
to make this, I wanted it to be automatic, so I made Rails make it for
me!

On a recent site I was helping make I needed a sitemap page.

This site uses a Page model which defines each page. Every page has a
published attribute which is either true or false (ie, is the page live
or not?)

These instructions are going to be fairly broad so you can apply them to
any site you are using. The only requirement really is that you have
some object which can return a full URL, it's last modified time (which
you can get for free using the ActiveRecord "updated_at" magic field)
and if it is published or not.

Ok, got that? Good. Now without further ado we will get into the code.

First, generate a controller for this sitemap, for originality we will
call it... umm... "sitemap" !

``` shell
baci: mikel$ ruby script/generate controller sitemap
  exists  app/controllers/
  exists  app/helpers/
  create  app/views/sitemap
  exists  test/functional/
  create  app/controllers/sitemap_controller.rb
  create  test/functional/sitemap_controller_test.rb
  create  app/helpers/sitemap_helper.rb
```

Open up the sitemap_controller.rb file and we need a method (we'll call
it XML) to generate the xml sitemap.

For simplicity I won't go through the RSpec / Testing parts...

``` ruby
def xml
  @headers['Content-Type'] = "application/xml"
  @pages = Page.find_published_pages
  render :layout => false
end
```

So, what we did there was set the header content type to
application/xml, this is fairly important.

Then we are finding the published pages for the site.

Then we are calling `<strong>`{=html}render :layout =\>
false`</strong>`{=html} This is important as it stops any of your files
in the views/layouts/ folder from being wrapped around the output. We
want raw XML.

OK?

Good.

So next, lets make that find_published_pages class method on Page (or
whatever model you are using)

``` ruby
class Page < ActiveRecord::Base

  def self.find_published_pages
    find(:all, :conditions => ["published = ?", true])
  end

end
```

This is fairly straight forward, find the pages which have the published
field set to true.

OK, so now as a result of this, the sitemap controller is going to
create a set of pages (called, imaginatively, \@pages) which are
published and pass it onto the view for processing.... what view?

This one!

So... now, the `<strong>`{=html}script/generate`</strong>`command would have created a views/sitemap folder. Go into here and make
a file called `<strong>`{=html}sitemap.rxml`</strong>`
In this view we need to create a sitemap template per the protocol at
[www.sitemap.org](http://www.sitemap.org/), fortunately this is fairly
simple. Open the xml.rxml folder and put the following into it:

``` ruby
base_url = "http://www.yoururl.org"
xml.instruct! :xml, :version=>"1.0"
xml.tag! 'urlset', "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do
  for page in @pages do
    xml.tag! 'url' do
      xml.tag! 'loc', "#{base_url}#{page.generate_url}"
      xml.tag! 'lastmod', page.updated_at.strftime("%Y-%m-%d")
      xml.tag! 'changefreq', 'monthly'
      xml.tag! 'priority', '0.8'
    end
  end
end
```

What this does is first define the base_url at the top, put in the xml
instruction at the top, then wraps all the urls in a urlset tag.

Then each url "block" gets rendered and created with the last updated
time of that page.

Things you could do to make this cleaner is move that ugly
updated_at.strftime into a helper method and clean up the way we call
base_url.

Two last things, you need to make a method in your Page model called
"generate_url" which gives you back the full url of this page. in this
app, I am using natural urls, no ID or date in them, so I have a custom
method for this, you can also call url for with some parameters like
trailing slash etc... but you need to adapt this bit to your site.

One last thing is to make the right route in the routes.rb file like so:

``` ruby
map.sitemap "/sitemap.xml", :controller => "sitemap", :action => "xml"
```

Make sure you put this towards the top of your routes file.

This will then generate a sitemap.xml file when you point your browser
at http://www.yoururl.org/sitemap.xml that looks something like this:

``` xml
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>http://www.yoururl.org/</loc>
    <lastmod>2007-11-07</lastmod>
    <changefreq>monthly</changefreq>
    <priority>0.8</priority>
  </url>
  <url>
    <loc>http://www.yoururl.org/products/</loc>
    <lastmod>2007-11-07</lastmod>
    <changefreq>monthly</changefreq>
    <priority>0.8</priority>
  </url>
  <url>
    <loc>http://www.yoururl.org/conventions/</loc>
    <lastmod>2007-11-07</lastmod>
    <changefreq>monthly</changefreq>
    <priority>0.8</priority>
  </url>
  <url>
    <loc>http://www.yoururl.org/memberships/</loc>
    <lastmod>2007-11-07</lastmod>
    <changefreq>monthly</changefreq>
    <priority>0.8</priority>
  </url>
  <url>
    <loc>http://www.yoururl.org/about_us/</loc>
    <lastmod>2007-11-07</lastmod>
    <changefreq>monthly</changefreq>
    <priority>0.8</priority>
  </url>
</urlset>
```

Which gets updated every time you update a page and or create a new page
or delete an old page.

Pretty cool yeah?

blogLater

Mikel
