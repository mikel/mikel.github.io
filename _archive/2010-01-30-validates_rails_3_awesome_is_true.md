---
title: "validates :rails_3, :awesome => true"
author: Mikel Lindsaar
date: 2010-01-30
layout: post
redirect_from:
  - /2010/1/30/validates_rails_3_awesome_is_true
  - /2010/1/31/validates_rails_3_awesome_is_true
---
The new validation methods in Rails 3.0 have been extracted out to
Active Model, but in the process have been sprinkled with DRY
goodness...

As you would know from Yehuda's post on [Active Model
abstraction](http://yehudakatz.com/2010/01/10/activemodel-make-any-ruby-object-feel-like-activerecord/),
in Rails 3.0, Active Record now mixes in many aspects of Active Model,
including the validates modules.

Before we get started though, your old friends still exist:

-   `validates_acceptance_of`
-   `validates_associated`
-   `validates_confirmation_of`
-   `validates_each`
-   `validates_exclusion_of`
-   `validates_format_of`
-   `validates_inclusion_of`
-   `validates_length_of`
-   `validates_numericality_of`
-   `validates_presence_of`
-   `validates_size_of`
-   `validates_uniqueness_of`

Are still around and not going anywhere, but Rails version 3 offers you
some cool, nay, awesome alternatives:

### Introducing the validates method

The Validates method accepts an attribute, followed by a hash of
validation options.

Which means you can type something like:

``` ruby
class Person < ActiveRecord::Base
  validates :email, :presence => true
end
```

The options you can pass in to
`<span class="ruby">`{=html}validates`</span>`{=html} are:

-   `:acceptance => Boolean`
-   `:confirmation => Boolean`
-   `:exclusion => { :in => Ennumerable }`
-   `:inclusion => { :in => Ennumerable }`
-   `:format => { :with => Regexp }`
-   `:length => { :minimum => Fixnum, maximum => Fixnum, }`
-   `:numericality => Boolean`
-   `:presence => Boolean`
-   `:uniqueness => Boolean`

Which gives you a huge range of easily usable, succinct options for your
attributes and allows you to place your validations for each attribute
in one place.

So for example, if you had to validate name and email, you might do
something like this:

``` ruby
# app/models/person.rb
class User < ActiveRecord::Base
  validates :name,  :presence => true, 
                    :length => {:minimum => 1, :maximum => 254}

  validates :email, :presence => true, 
                    :length => {:minimum => 3, :maximum => 254},
                    :uniqueness => true,
                    :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}

end
```

This allows us to be able to look at a model and easily see the
validations in one spot for each attribute, win for code readability!

### Extracting Common Use Cases

However, the `<span class="ruby">`{=html}:format =\> {:with =\>
EmailRegexp}`</span>`{=html} is a bit of a drag to retype everywhere,
and definitely fits the idea of a reusable validation that we might want
to use in other models.

And what if you wanted to use a really impressive Regular Expression
that takes more than a few characters to type to show that you know how
to Google?

Well, validations can also except a custom validation.

To use this, we first make an
`<span class="ruby">`{=html}email_validator.rb`</span>`{=html} file in
`<span class="ruby">`{=html}Rails.root`</span>`{=html}'s lib directory:

``` ruby
# lib/email_validator.rb
class EmailValidator < ActiveModel::EachValidator

  EmailAddress = begin
    qtext = '[^\\x0d\\x22\\x5c\\x80-\\xff]'
    dtext = '[^\\x0d\\x5b-\\x5d\\x80-\\xff]'
    atom = '[^\\x00-\\x20\\x22\\x28\\x29\\x2c\\x2e\\x3a-' +
      '\\x3c\\x3e\\x40\\x5b-\\x5d\\x7f-\\xff]+'
    quoted_pair = '\\x5c[\\x00-\\x7f]'
    domain_literal = "\\x5b(?:#{dtext}|#{quoted_pair})*\\x5d"
    quoted_string = "\\x22(?:#{qtext}|#{quoted_pair})*\\x22"
    domain_ref = atom
    sub_domain = "(?:#{domain_ref}|#{domain_literal})"
    word = "(?:#{atom}|#{quoted_string})"
    domain = "#{sub_domain}(?:\\x2e#{sub_domain})*"
    local_part = "#{word}(?:\\x2e#{word})*"
    addr_spec = "#{local_part}\\x40#{domain}"
    pattern = /\A#{addr_spec}\z/
  end

  def validate_each(record, attribute, value)
    unless value =~ EmailAddress
      record.errors[attribute] << (options[:message] || "is not valid") 
    end
  end

end
```

As each file in the lib directory gets loaded automatically by Rails,
and as our class inherits from
`<span class="ruby">`{=html}ActiveModel::EachValidator`</span>`{=html}
the class name is used to create a dynamic validator that you can then
use in any object that makes use of the
`<span class="ruby">`{=html}ActiveModel::Validations`</span>`{=html} mix
in, such as Active Record objects.

The name of the dynamic validation option is based on whatever is to the
left of "Validator" down-cased and underscorized.

So now in our User class we can simply change it to:

``` ruby
# app/models/person.rb
class User < ActiveRecord::Base
  validates :name,  :presence => true, 
                    :length => {:minimum => 1, :maximum => 254}

  validates :email, :presence => true, 
                    :length => {:minimum => 3, :maximum => 254},
                    :uniqueness => true,
                    :email => true

end
```

Notice the `<span class="ruby">`{=html}:email =\> true`</span>`{=html}
call? This is much cleaner and simple, and more importantly, reusable.

Now in our console, we will see something like:

``` shell
 $ ./script/console 
Loading development environment (Rails 3.0.pre)
?> u = User.new(:name => 'Mikel', :email => 'bob')
=> #<User id: nil, name: "Mikel", email: "bob", created_at: nil, updated_at: nil>
>> u.valid?
=> false
>> u.errors
=> #<OrderedHash {:email=>["is not valid"]}>
```

With our custom error message "is not valid" showing up in the email.

### Class Wide Validations

But what if you had, say, three different models, users, visitors and
customers, all of which shared some common validations, but were
different enough that you had to separate them out?

Well, you could use another custom validator, but pass it to your models
as a `<span class="ruby">`{=html}validates_with`</span>`{=html} call:

``` ruby
# app/models/person.rb
class User < ActiveRecord::Base
  validates_with HumanValidator
end

# app/models/person.rb
class Visitor < ActiveRecord::Base
  validates_with HumanValidator
end

# app/models/person.rb
class Customer < ActiveRecord::Base
  validates_with HumanValidator
end
```

You could then make a file in your lib directory like so:

``` ruby
class HumanValidator < ActiveModel::Validator

  def validate(record)
    record.errors[:base] << "This person is dead" unless check(human)
  end

  private

    def check(record)
      (record.age < 200) && (record.age > 0)
    end

end
```

Which is an obviously contrived example, but would produce this result
in our console:

``` shell
$ ./script/console 
Loading development environment (Rails 3.0.pre)
>> u = User.new
=> #<User id: nil, name: nil, email: nil, created_at: nil, updated_at: nil>
>> u.valid?
=> false
>> u.errors
=> #<OrderedHash {:base=>["This person is dead"]}>
```

### Trigger times

As you would expect, any validates method can have the following sub
options added to them:

-   `:on`
-   `:if`
-   `:unless`
-   `:allow_blank`
-   `:allow_nil`

Each of these can take a call to a method on the record itself. So we
could have:

``` ruby
class Person < ActiveRecord::Base

  validates :post_code, :presence => true, :unless => :no_postcodes?

  def no_postcodes?
    ['TW'].include?(country_iso)
  end

end
```

I think you can see this gives you a huge amount of flexibility.

### Credits

Kudos to [Jamie
Hill](http://thelucid.com/2010/01/08/sexy-validation-in-edge-rails-rails-3/),
[José Valim](http://blog.plataformatec.com.br/) and [Joshua
Peek](http://joshpeek.com/) for getting [the
patch](https://rails.lighthouseapp.com/projects/8994/tickets/3058-patch-sexy-validations)
in.

