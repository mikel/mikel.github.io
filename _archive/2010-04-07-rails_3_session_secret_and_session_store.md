---
title: "Rails 3 Session Secret and Session Store "
author: Mikel Lindsaar
date: 2010-04-07
layout: home
redirect_from:
  - /2010/4/7/rails_3_session_secret_and_session_store
---
In Rails 3 the location and way you declare the session secret and
session store have changed.

Rails 3 Session Secret and Session Store

In Rails 3 the location and way you declare the session secret and
session store have changed.

Previously (in 2.3.x) you would have one file:

`config/initializers/session_store.rb`

``` ruby
ActionController::Base.session = {
  :key         => '_my_app_name_session',
  :secret      => 'somereallylongrandomkey'
}
```

In Rails 3, you reduce `session_store.rb` to the following:

``` ruby
Rails.application.config.session_store :cookie_store, :key => "_my_app_name_session"
```

And then, because we now need somewhere to store the secret, you create
a new file called `config/initializers/cookie_verification_secret.rb`
and put inside of it:

``` ruby
Rails.application.config.cookie_secret = 'somereallylongrandomkey'
```

If instead of using cookies, you were using active record as the store,
then you obviously wouldn't need the `cookie_verification_secret.rb`
file and instead would insert any other config you needed into its own
file inside of initializers.

This gives us the added bonus of being able to exclude cookie secrets
from source control systems.

blogLater

Mikel
