---
title: "How to rename a Rails 3 Application"
author: Mikel Lindsaar
date: 2010-01-18
layout: home
redirect_from:
  - /2010/1/18/rename-rails-3-application
  - /2010/1/19/rename-rails-3-application
---
Renaming a Rails 3 application is something you have to think about now.
No, really... :)

When you create a new Rails 3.0 app with "rails app_name" Rails will
create the application for you like before, but with a major difference.

It will Classify your "app_name" and use this as the Ruby name space for
your application.

So if you do:

``` shell
rails new app_name
```

Then your Rails application will have sprinklings of
`<span style="font-weight:bold">`{=html}AppName`</span>`{=html}
throughout the tree.

If you later decide that your application should be called something
more specific than "AppName" you need to replace out AppName from the
following files:

``` shell
config/application.rb
config/environment.rb
config/environments/development.rb
config/environments/test.rb
config/environments/production.rb
config/routes.rb
config.ru
initializers/secret_token.rb
initializers/session_store.rb
```

Of course, if you are using TextMate, a simple Project wide search and
replace for AppName with your new name, should do the trick. But it is
something to be aware of.

blogLater

Mikel

Edited 21 Sept 2010: to update per reader comments below.
