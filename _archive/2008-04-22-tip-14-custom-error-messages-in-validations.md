---
title: "Tip #14 - Custom Error Messages in Validations"
author: Mikel Lindsaar
date: 2008-04-22
layout: post
redirect_from:
  - /2008/4/22/tip-14-custom-error-messages-in-validations
---
If you use Rails, you sometimes get a situation where the custom error
messages just don't work, here is how you can fix it...

Say you have a model with a field called 'country_iso' which specifies
the ISO value of the country the person belongs to.

Database design concerns aside (you should really have it as country_id
and a separate country_iso field) you might be stuck with this situation
from a legacy database (like I was).

As this is a required field, you set the following in your model:

``` ruby
class User < ActiveRecord::Base
  validates_presence_of :country_iso
end
```

So, you go ahead and make a form which presents the country as just a
select box, because you don't want your users to worry about if Thailand
is TH or TL, but then you don't specify a country and the error message
comes back to the user in nice big letters:

`<span style="color:red">`{=html}Country Iso can't be
blank`</span>`
#### Ugh!

Aside from the fact that Iso is capitalized badly, how many of YOUR
users know that it stands for "International Standards Organization" and
that a Country ISO is usually a two letter representation of the
country? I'd wager about 3 of them have some idea :)

So you go in and change the validates line to:

``` ruby
class User < ActiveRecord::Base
  validates_presence_of :country_iso, :message => "Country can't be blank"
end
```

Do your test again, and now you get:

`<span style="color:red">`{=html}Country Iso Country can't be
blank`</span>`
Nup.. that'd didn't really fix it.

Fortunately, the fix is easy:

``` ruby
class User < ActiveRecord::Base
  validate do |user|
    user.errors.add_to_base("Country can't be blank") if user.country_iso.blank?
  end
end
```

Now, reload your view and you'll get:

`<span style="color:red">`{=html}Country can't be blank`</span>`
Much better!

blogLater

Mikel

